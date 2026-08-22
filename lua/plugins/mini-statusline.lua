-- ---------------------------------------------------------------------------
-- mini.statusline
-- ---------------------------------------------------------------------------
--
-- While the default statusline is sufficient, there are several enhancements
-- that I've made to improve usability and readability:
--
-- 1. Don't show file encoding or file size as I've never needed this info.
-- 2. Don't show total lines or chars -- only show current line and column.
-- 3. Add visual separation between search results, lines, and column.
-- 4. Deemphasize the directory from the filename, and distinguish a modified
--    filename. Uses MiniStatuslineDirectory / MiniStatuslineInactive /
--    MiniStatuslineFilename / MiniStatuslineFilenameModified.
-- 5. Move diagnostics to the right, next to filetype and LSP, to group them
--    and reduce noise on the Git-heavy left side.

local loader = require("config.loader")
local statusline = require("mini.statusline")

local H = {}

loader.now(function()
  statusline.setup({
    use_icons = true,
    content = {
      inactive = function()
        local pathname = H.section_pathname({ trunc_width = 120 })
        return statusline.combine_groups({
          { hl = "MiniStatuslineInactive", strings = { pathname } },
        })
      end,
      active = function()
        -- stylua: ignore start
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git           = statusline.section_git({ trunc_width = 40 })
        local diff          = statusline.section_diff({ trunc_width = 80 })
        local diagnostics   = statusline.section_diagnostics({ trunc_width = 60 })
        local lsp           = statusline.section_lsp({ trunc_width = 40 })
        local filetype      = H.section_filetype({ trunc_width = 70 })
        local location      = H.section_location({ trunc_width = 120 })
        local recording     = H.section_recording({ trunc_width = 120 })
        local search        = H.section_searchcount({ trunc_width = 80 })
        local pathname      = H.section_pathname({
          trunc_width = 100,
          filename_hl = "MiniStatuslineFilename",
          modified_hl = "MiniStatuslineFilenameModified",
        })

        -- Usage of `combine_groups()` ensures highlighting and correct padding
        -- with spaces between groups (accounts for 'missing' sections, etc.)
        return statusline.combine_groups({
          { hl = mode_hl,                   strings = { mode:upper() } },
          { hl = "MiniStatuslineDevinfo",   strings = { git, diff } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineDirectory", strings = { pathname } },
          "%=", -- End left alignment
          { hl = "DiagnosticWarn",          strings = { recording } },
          { hl = "MiniStatuslineFileinfo",  strings = { diagnostics, filetype, lsp } },
          { hl = mode_hl,                   strings = { search .. location } },
          { hl = "MiniStatuslineDirectory", strings = {} },
        })
        -- stylua: ignore end
      end,
    },
  })
end)

H.isnt_normal_buffer = function() return vim.bo.buftype ~= "" end

H.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if not has_devicons then return "" end

  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  return devicons.get_icon(file_name, file_ext, { default = true })
end

H.section_location = function(args)
  -- Use virtual column number to allow update when past last column
  if statusline.is_truncated(args.trunc_width) then return "%-2l│%-2v" end

  return "󰉸 %-2l│󱥖 %-2v"
end

H.section_filetype = function(args)
  local filetype = vim.bo.filetype
  if statusline.is_truncated(args.trunc_width) or filetype == "" or H.isnt_normal_buffer() then return "" end

  local icon = H.get_filetype_icon()
  if icon == "" then return filetype end
  return string.format("%s %s", icon, filetype)
end

H.section_recording = function(args)
  local is_recording = vim.fn.reg_recording()
  if is_recording == "" then return "" end
  local msg = statusline.is_truncated(args.trunc_width) and "" or "recording "
  return string.format("%s%s", msg, is_recording)
end

H.section_searchcount = function(args)
  if vim.v.hlsearch == 0 then return "" end
  -- `searchcount()` can error when evaluated often (e.g. `/` then `\(` gives
  -- E54), so guard it with pcall.
  local ok, s_count = pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then return "" end

  local icon = statusline.is_truncated(args.trunc_width) and "" or " "
  if s_count.incomplete == 1 then return icon .. "?⧸?│" end

  local too_many = string.format(">%d", s_count.maxcount)
  local current = s_count.current > s_count.maxcount and too_many or s_count.current
  local total = s_count.total > s_count.maxcount and too_many or s_count.total
  return string.format("%s%s⧸%s│", icon, current, total)
end

H.section_pathname = function(args)
  args = args or {}
  if vim.bo.buftype == "terminal" then return "%t" end

  local sep = package.config:sub(1, 1)
  local cwd = vim.uv.fs_realpath(vim.uv.cwd() or "") or ""
  local path = vim.fn.expand("%:p")
  if path:find(cwd, 1, true) == 1 then path = path:sub(#cwd + 2) end

  local parts = vim.split(path, sep)
  if statusline.is_truncated(args.trunc_width or 80) and #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end

  local dir = ""
  if #parts > 1 then dir = table.concat(parts, sep, 1, #parts - 1) .. sep end

  local hl = args.filename_hl
  if vim.bo.modified then hl = args.modified_hl end
  local file_hl = hl and ("%#" .. hl .. "#") or ""
  local modified = vim.bo.modified and " [+]" or ""
  return dir .. file_hl .. parts[#parts] .. modified
end
