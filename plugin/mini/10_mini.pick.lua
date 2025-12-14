-- ---------------------------------------------------------------------------
-- mini.pick
-- ---------------------------------------------------------------------------

local H = {}
Config.later(function()
  require("mini.pick").setup({
    source = {
      preview = function(buf_id, item)
        return MiniPick.default_preview(buf_id, item, { line_position = "center" })
      end,
    },
    window = {
      prompt_prefix = "❯ ",
    },
  })

  vim.ui.select = MiniPick.ui_select

  -- ---------------------------------------------------------------------------
  -- Custom pickers
  -- ---------------------------------------------------------------------------

  -- Config picker
  MiniPick.registry.config = function()
    return MiniPick.builtin.files(
      nil,
      { source = { name = "Config Files", cwd = vim.fn.stdpath("config") } }
    )
  end

  -- Buffer picker with delete
  MiniPick.registry.buffers = function(local_opts)
    local wipeout_cur = function()
      vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
    end
    local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }
    MiniPick.builtin.buffers(local_opts, { mappings = buffer_mappings })
  end

  -- Plugin picker
  local plugin_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt"
  MiniPick.registry.plugins = H.two_stage_dir_picker(plugin_dir, "Plugin Picker")

  -- Project picker
  local repo_dir = vim.fn.expand("~/repos")
  MiniPick.registry.projects = H.two_stage_dir_picker(repo_dir, "Repo Picker")

  -- Aligned grep picker
  MiniPick.registry.grep_align = function(opts)
    MiniPick.builtin.grep(opts, { source = { show = H.grep_align_on_nul } })
  end

  -- Aligned live grep picker
  MiniPick.registry.grep_live_align = function(opts)
    MiniPick.builtin.grep_live(opts, { source = { show = H.show_aligned_grep_results } })
  end

  -- Aligned lsp picker
  MiniPick.registry.lsp_align = function(opts)
    MiniExtra.pickers.lsp(opts, { source = { show = H.show_aligned_lsp_results } })
  end

  -- Aligned and highlighted TODO picker
  MiniPick.registry.grep_todo_keywords = function(opts)
    opts.pattern = "(TODO|FIXME|HACK|NOTE):"
    MiniPick.builtin.grep(opts, {
      source = {
        show = function(buf_id, items, query)
          H.grep_align_on_nul(buf_id, items, query)
          H.minipick_highlight_keywords(buf_id)
        end,
      },
    })
  end
end)

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Creates a two-stage directory picker. First stage picks a directory inside
-- `dir` with the explorer, then the second stage opens a file picker inside
-- the chosen directory.
H.two_stage_dir_picker = function(dir, name)
  local pred = function(item) return item.text ~= ".." end
  local choose = function(item)
    vim.schedule(
      function() MiniPick.builtin.files(nil, { source = { name = item.text, cwd = item.path } }) end
    )
  end
  return function()
    local local_opts = { cwd = dir, filter = pred }
    local opts = { source = { name = name, choose = choose } }
    return MiniExtra.pickers.explorer(local_opts, opts)
  end
end

-- items is a table in this shape (NUL byte separators):
--    {
--      "what\0we are\0aligning",
--      "what\0I am\0trying to align",
--    }
H.show_aligned_grep_results = function(buf_id, items, query)
  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  items = H.map_gsub(items, "^%Z+", H.truncate_path(4))

  -- Because items is an array of blobs (contains a NUL byte), align_strings
  -- will not work because it expects strings. So, convert the NUL bytes to a
  -- unique (hopefully) separator, then align, and revert back.
  items = H.map_gsub(items, "%z", "#|#")
  items = MiniAlign.align_strings(items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = " ",
    split_pattern = "#|#",
  })
  items = H.map_gsub(items, "#|#", "\0")

  -- Back to the regularly scheduled program :-)
  MiniPick.default_show(buf_id, items, query)
end

-- items is a table in this shape ('│' separators):
--    {
--      { start = 1, end = 10, path ="blah", text = "what│we are│aligning" },
--      { start = 1, end = 10, path ="blah", text = "what│I am│trying to align" },
--    }
H.show_aligned_lsp_results = function(buf_id, items, query)
  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  local item_texts = vim.tbl_map(
    function(item) return item.text:gsub("^[^│]+", H.truncate_path(4)) end,
    items
  )

  item_texts = MiniAlign.align_strings(item_texts, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = " ",
    split_pattern = "│",
  }, { pre_justify = { MiniAlign.gen_step.trim("both", "remove") } })

  for i, item in ipairs(items) do
    item.text = item_texts[i]
  end

  -- Back to the regularly scheduled program :-)
  MiniPick.default_show(buf_id, items, query)

  -- Highlight the lines
  local ns_id = vim.api.nvim_get_namespaces()["MiniExtraPickers"]
  pcall(vim.api.nvim_buf_clear_namespace, buf_id, ns_id, 0, -1)
  for i, item in ipairs(items) do
    local opts = { end_row = i, end_col = 0, hl_mode = "blend", hl_group = item.hl, priority = 199 }
    vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, opts)
  end
end

H.minipick_highlight_keywords = function(bufnr)
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
      if start_idx and end_idx then
        -- Highlights the keyword
        extmark_opts.hl_group = hl_group.keyword
        extmark_opts.end_row = row - 1
        extmark_opts.end_col = end_idx - 1
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, start_idx - 1, extmark_opts)

        -- Highlights the ':'
        extmark_opts.hl_group = hl_group.colon
        extmark_opts.end_col = end_idx
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, end_idx - 1, extmark_opts)

        -- -- Highlights the rest of the line
        extmark_opts.hl_group = hl_group.body
        extmark_opts.end_col = #line
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, end_idx, extmark_opts)
      end
    end
  end
end

H.sep = package.config:sub(1, 1)
H.truncate_path = function(max_parts)
  max_parts = math.max(max_parts, 3)
  return function(path)
    local absolute = path:sub(1, 1) == H.sep
    local parts = vim.split(path, H.sep)
    parts = absolute and vim.list_slice(parts, 2, #parts) or parts
    if #parts > max_parts then parts = { parts[1], "󰇘", parts[#parts - 1], parts[#parts] } end
    return (absolute and H.sep or "") .. table.concat(parts, H.sep)
  end
end

H.map_gsub = function(items, pattern, replacement)
  return vim.tbl_map(function(item)
    item, _ = string.gsub(item, pattern, replacement)
    return item
  end, items)
end

H.keyword_to_hl_groups = function(keyword)
  keyword = keyword:sub(1, 1):upper() .. keyword:sub(2):lower()
  return {
    keyword = "MiniHipatterns" .. keyword,
    colon = "MiniHipatterns" .. keyword .. "Colon",
    body = "MiniHipatterns" .. keyword .. "Body",
  }
end
