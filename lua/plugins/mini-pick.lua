-- ---------------------------------------------------------------------------
-- mini.pick
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

-- Private helpers, defined BELOW the loader.later block so the main logic
-- leads the file. Safe because field access on the pre-bound H is a runtime
-- lookup and the later thunk runs only after the whole module has loaded --
-- a loader.now thunk could NOT reference H fields defined below it.
local H = {}

loader.later(function()
  local pick = require("mini.pick")
  pick.setup({
    source = {
      preview = function(buf_id, item) pick.default_preview(buf_id, item, { line_position = "center" }) end,
    },
    window = { prompt_prefix = "❯ " },
  })

  vim.ui.select = pick.ui_select

  -- Config picker
  pick.registry.config = function()
    pick.builtin.files(nil, { source = { name = "Config Files", cwd = vim.fn.stdpath("config") } })
  end

  -- Buffer picker with modified indicator
  local modified_ns = vim.api.nvim_create_namespace("kaz-modified-buffer-markers")
  pick.registry.buffers = function(local_opts)
    local add_modified_marker = function(buf_id, row)
      vim.api.nvim_buf_set_extmark(buf_id, modified_ns, row, 0, {
        virt_text = { { "[+]", "DiagnosticHint" } },
        virt_text_pos = "eol",
      })
    end

    local show_with_modified_marker = function(buf_id, items, query)
      pick.default_show(buf_id, items, query, { show_icons = true })
      for i, item in ipairs(items) do
        if vim.bo[item.bufnr].modified then add_modified_marker(buf_id, i - 1) end
      end
    end

    pick.builtin.buffers(local_opts, { source = { show = show_with_modified_marker } })
  end

  -- Plugin picker
  local plugin_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt"
  pick.registry.plugins = H.two_stage_dir_picker(plugin_dir, "Plugin Picker")

  -- Project picker
  pick.registry.projects = H.two_stage_dir_picker(vim.fn.expand("~/repos"), "Repo Picker")

  -- Aligned grep picker
  pick.registry.grep_align = function(opts) pick.builtin.grep(opts, { source = { show = H.show_aligned_grep_results } }) end

  -- Aligned live grep picker
  pick.registry.grep_live_align = function(opts)
    pick.builtin.grep_live(opts, { source = { show = H.show_aligned_grep_results } })
  end

  -- Aligned lsp picker
  pick.registry.lsp_align = function(opts)
    require("mini.extra").pickers.lsp(opts, { source = { show = H.show_aligned_lsp_results } })
  end

  -- Aligned and highlighted TODO picker
  pick.registry.grep_todo_keywords = function(opts)
    opts.pattern = "(TODO|FIXME|HACK|NOTE):"
    pick.builtin.grep(opts, {
      source = {
        show = function(buf_id, items, query)
          H.show_aligned_grep_results(buf_id, items, query)
          H.highlight_keywords(buf_id)
        end,
      },
    })
  end
end)

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local sep = package.config:sub(1, 1)

H.truncate_path = function(max_parts)
  max_parts = math.max(max_parts, 3)
  return function(path)
    local absolute = path:sub(1, 1) == sep
    local parts = vim.split(path, sep)
    if absolute then parts = vim.list_slice(parts, 2, #parts) end
    local n = #parts
    if n > max_parts then parts = { parts[1], "󰇘", parts[n - 1], parts[n] } end
    return (absolute and sep or "") .. table.concat(parts, sep)
  end
end

H.map_gsub = function(items, pattern, replacement)
  return vim.tbl_map(function(item) return (item:gsub(pattern, replacement)) end, items)
end

H.keyword_to_hl_groups = function(keyword)
  keyword = keyword:sub(1, 1):upper() .. keyword:sub(2):lower()
  return {
    keyword = "MiniHipatterns" .. keyword,
    colon = "MiniHipatterns" .. keyword .. "Colon",
    body = "MiniHipatterns" .. keyword .. "Body",
  }
end

-- items is a table in this shape (NUL byte separators):
--    {
--      "what\0we are\0aligning",
--      "what\0I am\0trying to align",
--    }
H.show_aligned_grep_results = function(buf_id, items, query)
  local pick = require("mini.pick")
  local align = require("mini.align")

  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  items = H.map_gsub(items, "^%Z+", H.truncate_path(4))

  -- Because items is an array of blobs (contains a NUL byte), align_strings
  -- will not work because it expects strings. So, convert the NUL bytes to
  -- a unique (hopefully) separator, then align, and revert back.
  items = H.map_gsub(items, "%z", "#|#")
  items = align.align_strings(items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = " ",
    split_pattern = "#|#",
  })
  items = H.map_gsub(items, "#|#", "\000")

  -- Back to the regularly scheduled program :-)
  pick.default_show(buf_id, items, query)
end

-- items is a table in this shape ('│' separators):
--    {
--      { start = 1, end = 10, path ="blah", text = "what│we are│aligning" },
--      { start = 1, end = 10, path ="blah", text = "what│I am│trying to align" },
--    }
H.show_aligned_lsp_results = function(buf_id, items, query)
  local pick = require("mini.pick")
  local align = require("mini.align")

  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  local truncate = H.truncate_path(4)
  local item_texts = vim.tbl_map(function(item) return (item.text:gsub("^[^│]+", truncate)) end, items)
  item_texts = align.align_strings(item_texts, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = " ",
    split_pattern = "│",
  }, {
    pre_justify = { align.gen_step.trim("both", "remove") },
  })

  for i, item in ipairs(items) do
    item.text = item_texts[i]
  end

  -- Back to the regularly scheduled program :-)
  pick.default_show(buf_id, items, query)

  -- Highlight the lines
  local ns_id = vim.api.nvim_get_namespaces()["MiniExtraPickers"]
  pcall(vim.api.nvim_buf_clear_namespace, buf_id, ns_id, 0, -1)
  for i, item in ipairs(items) do
    vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, {
      end_row = i,
      end_col = 0,
      hl_mode = "blend",
      hl_group = item.hl,
      priority = 199,
    })
  end
end

H.highlight_keywords = function(bufnr)
  local ns_id = vim.api.nvim_create_namespace("kaz-keywords")

  local keywords = {}
  for _, keyword in ipairs({ "TODO", "FIXME", "HACK", "NOTE" }) do
    keywords[" " .. keyword .. ":"] = H.keyword_to_hl_groups(keyword)
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local extmark_opts = { hl_mode = "combine", priority = 201 }
  for row, line in ipairs(lines) do
    for word, hl_group in pairs(keywords) do
      local start_idx, end_idx = line:find(word)
      -- find returns both indices or neither, so one check suffices
      if start_idx then
        -- Highlights the keyword
        extmark_opts.hl_group = hl_group.keyword
        extmark_opts.end_row = row - 1
        extmark_opts.end_col = end_idx - 1
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, start_idx - 1, extmark_opts)

        -- Highlights the ':'
        extmark_opts.hl_group = hl_group.colon
        extmark_opts.end_col = end_idx
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, end_idx - 1, extmark_opts)

        -- Highlights the rest of the line
        extmark_opts.hl_group = hl_group.body
        extmark_opts.end_col = #line
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, end_idx, extmark_opts)
      end
    end
  end
end

-- Creates a two-stage directory picker. First stage picks a directory inside
-- `dir` with the explorer, then the second stage opens a file picker inside
-- the chosen directory.
H.two_stage_dir_picker = function(dir, name)
  local pred = function(item) return item.text ~= ".." end

  local choose = function(item)
    vim.schedule(
      function() require("mini.pick").builtin.files(nil, { source = { name = item.text, cwd = item.path } }) end
    )
  end

  return function()
    require("mini.extra").pickers.explorer({ cwd = dir, filter = pred }, { source = { name = name, choose = choose } })
  end
end
