local H = {}
MiniDeps.later(function()
  require("mini.pick").setup({
    source = {
      preview = function(buf_id, item)
        return MiniPick.default_preview(buf_id, item, { line_position = "center" })
      end,
    },
  })

  vim.ui.select = MiniPick.ui_select

  ----------------------------------------
  -- Custom Pickers
  ----------------------------------------

  -- Config picker
  MiniPick.registry.config = function()
    return MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
  end

  -- Project picker
  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand("~/repos")
    local choose = function(item)
      vim.schedule(function()
        MiniPick.builtin.files(nil, { source = { cwd = item.path } })
      end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end

  -- Aligned Grep live picker
  MiniPick.registry.grep_live_align = function(opts)
    MiniPick.builtin.grep_live(opts, {
      source = { show = H.minipick_align_on_nul },
    })
  end

  -- Aligned TODO picker
  MiniPick.registry.grep_todo_keywords = function(opts)
    opts.pattern = "(TODO|FIXME|HACK|NOTE):"
    MiniPick.builtin.grep(opts, {
      source = {
        show = function(buf_id, items, query)
          H.minipick_align_on_nul(buf_id, items, query)
          H.minipick_highlight_keywords(buf_id)
        end,
      },
    })
  end

  ----------------------------------------
  -- Helpers
  ----------------------------------------

  H.minipick_align_on_nul = function(buf_id, items, query)
    -- Shorten the pathname to keep the width of the picker window to something
    -- a bit more reasonable for longer pathnames.
    items = H.map_gsub(items, "^%Z+", H.truncate_path(3))

    -- Because items is an array of blobs (contains a NUL byte), align_strings
    -- will not work because it expects strings. So, convert the NUL bytes to a
    -- unique (hopefully) separator, then align, and revert back.
    items = H.map_gsub(items, "%z", "#|#")
    items = MiniAlign.align_strings(items, {
      justify_side = { "left", "right", "right" },
      merge_delimiter = { "", " ", "", " ", "" },
      split_pattern = "#|#",
    })
    items = H.map_gsub(items, "#|#", "\0")

    -- Back to the regularly scheduled program :-)
    MiniPick.default_show(buf_id, items, query)
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
    max_parts = vim.fn.max({ max_parts, 3 })
    return function(path)
      local parts = vim.split(path, H.sep)
      if #parts > max_parts then
        parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
      end
      return table.concat(parts, H.sep)
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
end)
