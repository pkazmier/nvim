local H = {}

-- General utilities ========================================================
Config.dd = function(...)
  vim.notify(vim.inspect(...))
end

Config.toggle_hints = function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

-- Blink ====================================================================
Config.build_blink = function(params)
  vim.notify("Building blink.cmp", vim.log.levels.INFO)
  local obj = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify("Building blink.cmp done", vim.log.levels.INFO)
  else
    vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
  end
end

-- Leap =====================================================================
Config.leap_treesitter_select = function()
  require("leap.treesitter").select()
end

-- LuaLS from echasnovski config ============================================
H.filter_line_locations = function(locations)
  local present, res = {}, {}
  for _, l in ipairs(locations) do
    local t = present[l.filename] or {}
    if not t[l.lnum] then
      table.insert(res, l)
      t[l.lnum] = true
    end
    present[l.filename] = t
  end
  return res
end

H.show_location = function(location)
  local buf_id = location.bufnr or vim.fn.bufadd(location.filename)
  vim.bo[buf_id].buflisted = true
  vim.api.nvim_win_set_buf(0, buf_id)
  vim.api.nvim_win_set_cursor(0, { location.lnum, location.col - 1 })
  vim.cmd("normal! zv")
end

H.on_list = function(args)
  local items = H.filter_line_locations(args.items)
  if #items > 1 then
    vim.fn.setqflist({}, " ", { title = "LSP locations", items = items })
    return vim.cmd("botright copen")
  end
  H.show_location(items[1])
end

Config.luals_unique_definition = function()
  return vim.lsp.buf.definition({ on_list = H.on_list })
end

-- MiniDiff =================================================================
Config.minidiff_to_qf = function()
  vim.fn.setqflist(MiniDiff.export("qf"))
  vim.cmd("copen")
end

-- MiniFiles ================================================================
Config.minifiles_open_bufdir = function()
  local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
  MiniFiles.open(path, true)
end

-- MiniPick =================================================================
H.truncate_path = function(path)
  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep)
  if #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end
  return table.concat(parts, sep)
end

H.map_gsub = function(items, pattern, replacement)
  return vim.tbl_map(function(item)
    item, _ = string.gsub(item, pattern, replacement)
    return item
  end, items)
end

Config.minipick_align_on_nul = function(buf_id, items, query)
  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  -- items = map_gsub(items, "^%Z+", truncate_path)

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

Config.minipick_highlight_keywords = function(bufnr)
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

H.keyword_to_hl_groups = function(keyword)
  keyword = keyword:sub(1, 1):upper() .. keyword:sub(2):lower()
  return {
    keyword = "MiniHipatterns" .. keyword,
    colon = "MiniHipatterns" .. keyword .. "Colon",
    body = "MiniHipatterns" .. keyword .. "Body",
  }
end

-- MiniHues =================================================================
Config.minihues_apply_custom_highlights = function(p)
  local hi = function(name, data)
    vim.api.nvim_set_hl(0, name, data)
  end

  hi("Title", { fg = p.accent, bg = nil, bold = true })

  -- stylua: ignore start
  -- hi("BlinkCmpMenu",                { fg = p.fg, bg = p.bg })
  -- hi("BlinkCmpMenuBorder",          { fg = p.fg, bg = p.bg })
  -- hi("BlinkCmpDoc",                 { fg = p.fg, bg = p.bg })
  -- hi("BlinkCmpDocBorder",           { fg = p.fg, bg = p.bg })
  -- hi("BlinkCmpDocSeparator",        { fg = p.fg, bg = p.bg })
  -- hi("BlinkCmpSignatureHelp",       { fg = p.fg, bg = p.bg })
  -- hi("BlinkCmpSignatureHelpBorder", { fg = p.fg, bg = p.bg })

  -- hi("BlinkCmpMenu",                { link = 'NormalFloat' })
  -- hi("BlinkCmpMenuBorder",          { link = 'FloatBorder' })
  -- hi("BlinkCmpDoc",                 { link = 'NormalFloat' })
  -- hi("BlinkCmpDocBorder",           { link = 'FloatBorder' })
  -- hi("BlinkCmpSignatureHelp",       { link = 'NormalFloat' })
  -- hi("BlinkCmpSignatureHelpBorder", { link = 'FloatBorder' })

  -- Links to Comment by default, but that has italics
  hi("LeapBackdrop", { link = "MiniJump2dDim" })

  -- stylua: ignore start
  -- I prefer italic fonts as I use fonts with beautiful italics.
  -- Some examples: Operator Mono, Berkeley Mono, PragmataPro, Radon
  hi("Comment",                    { fg = p.fg_mid2, bg = nil,         italic = true })
  hi("DiagnosticVirtualTextError", { fg = p.red,     bg = p.red_bg,    italic = true })
  hi("DiagnosticVirtualTextHint",  { fg = p.cyan,    bg = p.cyan_bg,   italic = true })
  hi("DiagnosticVirtualTextInfo",  { fg = p.blue,    bg = p.blue_bg,   italic = true })
  hi("DiagnosticVirtualTextOk",    { fg = p.green,   bg = p.green_bg,  italic = true })
  hi("DiagnosticVirtualTextWarn",  { fg = p.yellow,  bg = p.yellow_bg, italic = true })

  -- Highlight patterns for highlighting the whole line and hiding colon.
  -- See https://github.com/echasnovski/mini.nvim/discussions/783
  hi("MiniHipatternsFixmeBody",  { fg = p.red })
  hi("MiniHipatternsFixmeColon", { bg = p.red,    fg = p.red,    bold = true })
  hi("MiniHipatternsHackBody",   { fg = p.yellow })
  hi("MiniHipatternsHackColon",  { bg = p.yellow, fg = p.yellow, bold = true })
  hi("MiniHipatternsNoteBody",   { fg = p.cyan })
  hi("MiniHipatternsNoteColon",  { bg = p.cyan,   fg = p.cyan,   bold = true })
  hi("MiniHipatternsTodoBody",   { fg = p.blue })
  hi("MiniHipatternsTodoColon",  { bg = p.blue,   fg = p.blue,   bold = true })

  -- Bold matches in MiniPick as well.
  hi("MiniPickMatchRanges",      { bg = nil, fg = p.cyan, bold = true})

  -- Highlight patterns for deemphasizing the directory name, so the
  -- filename is more prominent. Visually, this makes it faster to
  -- identify the name of the file.
  -- See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
  hi("MiniStatuslineDirectory",        { fg = p.fg_mid2, bg = p.accent_bg })
  hi("MiniStatuslineFilename",         { fg = p.fg_mid,  bg = p.accent_bg, bold = true })
  hi("MiniStatuslineFilenameModified", { fg = p.accent,  bg = p.accent_bg, bold = true })

  -- I like my vertical split divider to be the same color as my inactive
  -- horizontal status bar color, so it's consistent both vertically and
  -- horizontally when laststatus=2.
  hi("VertSplit",    { fg = p.bg_edge, bg = nil })
  hi("WinSeparator", { fg = p.bg_edge, bg = nil })
  -- stylua: ignore end
end

-- MiniMap ==================================================================
-- Toggle the global visibility of the map. If it is currently shown, then
-- hide it. If it is not, then show it if the current buffer is supposed to
-- have a map.
Config.minimap_toggle = function()
  vim.g.minimap_disable = not vim.g.minimap_disable
  if Config.minimap_should_be_enabled() then
    MiniMap.toggle()
  end
end

-- Toggle whether the current buffer should display a map if it has not been
-- globally disabled via M.toggle.
Config.minimap_buf_toggle = function()
  if Config.minimap_should_be_enabled() then
    vim.b.minimap_disable = true
    MiniMap.close()
  else
    vim.b.minimap_disable = false
    MiniMap.open()
  end
end

-- MiniStarter ==============================================================
Config.pad = function(str, n)
  return string.rep(" ", n) .. str
end

Config.greeting = function()
  local hour = tonumber(vim.fn.strftime("%H"))
  -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
  local part_id = math.floor((hour + 4) / 8) + 1
  local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
  local username = vim.loop.os_get_passwd()["username"] or "USERNAME"
  return ("Good %s, %s"):format(day_part, username)
end

Config.fortune = function()
  local ok, quote = pcall(function()
    local f = assert(io.popen("fortune -s", "r"))
    local s = assert(f:read("*a"))
    f:close()
    return s
  end)
  return ok and quote or nil
end

-- MiniSession ==============================================================
Config.session_save = function()
  local res = H.session_prompt("Save session as: ")
  if res ~= nil then
    MiniSessions.write(res)
  end
end

Config.session_delete = function()
  local res = H.session_prompt("Delete session: ")
  if res ~= nil then
    MiniSessions.delete(res, { force = true })
  end
end

-- For autocompletion of session name
Config.session_complete = function(arg_lead)
  return vim.tbl_filter(function(x)
    return x:find(arg_lead, 1, true) ~= nil
  end, vim.tbl_keys(MiniSessions.detected))
end

H.session_prompt = function(prompt)
  local completion = "customlist,v:lua.Config.session_complete"
  local ok, res = pcall(vim.fn.input, {
    prompt = prompt,
    cancelreturn = false,
    completion = completion,
  })
  if not ok or res == false then
    return nil
  end
  return res
end

-- MiniStatusline ===========================================================
Config.isnt_normal_buffer = function()
  return vim.bo.buftype ~= ""
end

Config.has_no_lsp_attached = function()
  return #vim.lsp.get_clients() == 0
end

Config.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if not has_devicons then
    return ""
  end

  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  return devicons.get_icon(file_name, file_ext, { default = true })
end

Config.section_location = function(args)
  -- Use virtual column number to allow update when past last column
  if MiniStatusline.is_truncated(args.trunc_width) then
    return "%-2l│%-2v"
  end

  return "󰉸 %-2l│󱥖 %-2v"
end

Config.section_filetype = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ""
  end

  local filetype = vim.bo.filetype
  if (filetype == "") or Config.isnt_normal_buffer() then
    return ""
  end

  local icon = Config.get_filetype_icon()
  if icon ~= "" then
    filetype = string.format("%s %s", icon, filetype)
  end

  return filetype
end

Config.section_searchcount = function(args)
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

Config.section_pathname = function(args)
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

-- zk-nvim ==================================================================
Config.new_meeting = function(opts)
  local zk = require("zk")
  local ui = require("zk.ui")
  local api = require("zk.api")

  opts = vim.tbl_extend("force", {
    select = { "title", "absPath" },
    tags = { "meeting" },
    sort = { "modified" },
    regex = "^%d+%-%d+%-%d+: (.-)$",
  }, opts or {})

  api.list(opts.notebook_path, opts, function(err, notes)
    assert(not err, tostring(err))
    local recent_notes = H.recent_meetings(notes, "title", opts.regex)
    local picker_opts = {
      title = "New Meeting",
      multi_select = false,
      minipick = {
        mappings = {
          ["new meeting"] = {
            char = "<C-e>",
            func = function()
              local query = MiniPick.get_picker_query()
              if query == nil then
                return true
              end
              local title = table.concat(query, "")
              zk.new(vim.tbl_extend("keep", { title = title }, opts))
              return true
            end,
          },
        },
      },
    }

    ui.pick_notes(recent_notes, picker_opts, function(note)
      local short_title = string.match(note.title, opts.regex)
      zk.new(vim.tbl_extend("keep", { title = short_title }, opts))
    end)
  end)
end

-- Returns a table of notes with duplicate entries removed. Duplicity is
-- determined by regex applied to the field entry of the note. The first
-- unique note found is kept, while others are discarded.
H.recent_meetings = function(notes, field, regex)
  local seen_notes = {}
  local unique_notes = {}
  for _, note in ipairs(notes) do
    local name = string.match(note[field], regex)
    if name and not seen_notes[name] then
      seen_notes[name] = true
      table.insert(unique_notes, note)
    end
  end
  return unique_notes
end
