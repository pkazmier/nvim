local H = {}

require("mini.statusline").setup({
  use_icons = true,
  content = {
    inactive = function()
      local pathname = H.section_pathname({ trunc_width = 120 })
      return MiniStatusline.combine_groups({
        { hl = "MiniStatuslineInactive", strings = { pathname } },
      })
    end,
    active = function()
      -- stylua: ignore start
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local diff          = MiniStatusline.section_diff({ trunc_width = 60 })
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 60 })
      local lsp           = MiniStatusline.section_lsp({ trunc_width = 40 })
      local filetype      = H.section_filetype({ trunc_width = 70 })
      local location      = H.section_location({ trunc_width = 120 })
      local search        = H.section_searchcount({ trunc_width = 80 })
      local pathname      = H.section_pathname({
        trunc_width = 100,
        filename_hl = "MiniStatuslineFilename",
        modified_hl = "MiniStatuslineFilenameModified" })

      -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
      -- correct padding with spaces between groups (accounts for 'missing'
      -- sections, etc.)
      return MiniStatusline.combine_groups({
        { hl = mode_hl,                   strings = { mode:upper() } },
        { hl = 'MiniStatuslineDevinfo',   strings = { git, diff } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineDirectory', strings = { pathname } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo',  strings = { filetype, diagnostics, lsp } },
        { hl = mode_hl,                   strings = { search .. location } },
      })
      -- stylua: ignore end
    end,
  },
})

-- Utility from mini.statusline
H.isnt_normal_buffer = function()
  return vim.bo.buftype ~= ""
end

H.has_no_lsp_attached = function()
  return #vim.lsp.get_clients() == 0
end

H.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if not has_devicons then
    return ""
  end

  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  return devicons.get_icon(file_name, file_ext, { default = true })
end

H.section_location = function(args)
  -- Use virtual column number to allow update when past last column
  if MiniStatusline.is_truncated(args.trunc_width) then
    return "%-2l│%-2v"
  end

  return "󰉸 %-2l│󱥖 %-2v"
end

H.section_filetype = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ""
  end

  local filetype = vim.bo.filetype
  if (filetype == "") or H.isnt_normal_buffer() then
    return ""
  end

  local icon = H.get_filetype_icon()
  if icon ~= "" then
    filetype = string.format("%s %s", icon, filetype)
  end

  return filetype
end

--- Section for current search count
---
--- Show the current status of |searchcount()|. Empty output is returned if
--- window width is lower than `args.trunc_width`, search highlighting is not
--- on (see |v:hlsearch|), or if number of search result is 0.
---
--- `args.options` is forwarded to |searchcount()|. By default it recomputes
--- data on every call which can be computationally expensive (although still
--- usually on 0.1 ms order of magnitude). To prevent this, supply
--- `args.options = { recompute = false }`.
H.section_searchcount = function(args)
  if vim.v.hlsearch == 0 then
    return ""
  end
  -- `searchcount()` can return errors because it is evaluated very often in
  -- statusline. For example, when typing `/` followed by `\(`, it gives E54.
  local ok, s_count = pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then
    return ""
  end

  local icon = MiniStatusline.is_truncated(args.trunc_width) and "" or " "
  if s_count.incomplete == 1 then
    return icon .. "?/?│"
  end

  local too_many = (">%d"):format(s_count.maxcount)
  local current = s_count.current > s_count.maxcount and too_many or s_count.current
  local total = s_count.total > s_count.maxcount and too_many or s_count.total
  return ("%s%s/%s│"):format(icon, current, total)
end

H.section_pathname = function(args)
  args = vim.tbl_extend("force", {
    modified_hl = nil,
    filename_hl = nil,
    trunc_width = 80,
  }, args or {})

  if vim.bo.buftype == "terminal" then
    return "%t"
  end

  local path = vim.fn.expand("%:p")
  local cwd = vim.uv.cwd() or ""
  cwd = vim.uv.fs_realpath(cwd) or ""

  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep)
  if require("mini.statusline").is_truncated(args.trunc_width) and #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end

  local dir = ""
  if #parts > 1 then
    dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep
  end

  local file = parts[#parts]
  local file_hl = ""
  if vim.bo.modified and args.modified_hl then
    file_hl = "%#" .. args.modified_hl .. "#"
  elseif args.filename_hl then
    file_hl = "%#" .. args.filename_hl .. "#"
  end
  local modified = vim.bo.modified and " [+]" or ""
  return dir .. file_hl .. file .. modified
end
