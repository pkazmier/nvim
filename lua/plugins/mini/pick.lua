require("mini.pick").setup({
  window = {
    config = {
      border = "single",
    },
  },
})

vim.ui.select = MiniPick.ui_select

-- Picker pre- and post-hooks ===============================================

-- Keys should be a picker source.name. Value is a callback function that
-- accepts same arguments as User autocommand callback.
local pre_hooks = {}
local post_hooks = {}

local group = vim.api.nvim_create_augroup("minipick-hooks", { clear = true })
local create_minipick_auto_command = function(pattern, desc, hooks)
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = pattern,
    group = group,
    desc = desc,
    callback = function(...)
      local opts = MiniPick.get_picker_opts()
      if opts and opts.source then
        local hook = hooks[opts.source.name] or function(...) end
        hook(...)
      end
    end,
  })
end
create_minipick_auto_command("MiniPickStart", "pre-hook for source.name", pre_hooks)
create_minipick_auto_command("MiniPickStop", "post-hook for source.name", post_hooks)

-- Neovim config picker =====================================================

MiniPick.registry.config = function()
  return MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end

-- Syntax buffer lines picker ===============================================
local ns_digit_prefix = vim.api.nvim_create_namespace("cur-buf-pick-show")
local show_cur_buf_lines = function(buf_id, items, query, opts)
  if items == nil or #items == 0 then
    return
  end

  -- Show as usual
  MiniPick.default_show(buf_id, items, query, opts)

  -- Move prefix line numbers into inline extmarks
  local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  local digit_prefixes = {}
  for i, l in ipairs(lines) do
    local _, prefix_end, prefix = l:find("^(%s*%d+│)")
    if prefix_end ~= nil then
      digit_prefixes[i], lines[i] = prefix, l:sub(prefix_end + 1)
    end
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  for i, pref in pairs(digit_prefixes) do
    local opts = { virt_text = { { pref, "MiniPickNormal" } }, virt_text_pos = "inline" }
    vim.api.nvim_buf_set_extmark(buf_id, ns_digit_prefix, i - 1, 0, opts)
  end

  -- Set highlighting based on the curent filetype
  local ft = vim.bo[items[1].bufnr].filetype
  local has_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
  local has_ts, _ = pcall(vim.treesitter.start, buf_id, has_lang and lang or ft)
  if not has_ts and ft then
    vim.bo[buf_id].syntax = ft
  end
end

MiniPick.registry.buffer_lines_current = function()
  local local_opts = { scope = "current", preserve_order = true } -- use preserve_order
  MiniExtra.pickers.buf_lines(local_opts, { source = { show = show_cur_buf_lines } })
end

local sep = package.config:sub(1, 1)
local function truncate_path(path)
  local parts = vim.split(path, sep)
  if #parts > 2 then
    parts = { parts[1], "…", parts[#parts] }
  end
  return table.concat(parts, sep)
end

local function map_gsub(items, pattern, replacement)
  return vim.tbl_map(function(item)
    item, _ = string.gsub(item, pattern, replacement)
    return item
  end, items)
end

local show_align_on_nul = function(buf_id, items, query, opts)
  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  items = map_gsub(items, "^%Z+", truncate_path)

  -- Because items is an array of blobs (contains a NUL byte), align_strings
  -- will not work because it expects strings. So, convert the NUL bytes to a
  -- unique (hopefully) separator, then align, and revert back.
  items = map_gsub(items, "%z", "#|#")
  items = MiniAlign.align_strings(items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = { "", " ", "", " ", "" },
    split_pattern = "#|#",
  })
  items = map_gsub(items, "#|#", "\0")

  -- Back to the regularly scheduled program :-)
  MiniPick.default_show(buf_id, items, query, opts)
end

MiniPick.registry.grep_live_align = function()
  MiniPick.builtin.grep_live({}, {
    source = { show = show_align_on_nul },
    window = { config = { width = math.floor(0.816 * vim.o.columns) } },
  })
end

-- Colorscheme picker =======================================================

local selected_colorscheme -- Currently selected or original colorscheme

pre_hooks.Colorschemes = function()
  selected_colorscheme = vim.g.colors_name
end

post_hooks.Colorschemes = function()
  vim.schedule(function()
    vim.cmd("colorscheme " .. selected_colorscheme)
  end)
end

MiniPick.registry.colorschemes = function()
  local colorschemes = vim.fn.getcompletion("", "color")
  return MiniPick.start({
    source = {
      name = "Colorschemes",
      items = colorschemes,
      choose = function(item)
        selected_colorscheme = item
      end,
      preview = function(buf_id, item)
        vim.cmd("colorscheme " .. item)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { item })
      end,
    },
  })
end
