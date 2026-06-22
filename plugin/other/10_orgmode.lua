-- ---------------------------------------------------------------------------
-- orgmode
-- ---------------------------------------------------------------------------

Config.now(function()
  vim.pack.add({
    "https://github.com/nvim-orgmode/orgmode",
    "https://github.com/nvim-orgmode/org-bullets.nvim",
  })
  -- nvim-orgmode configuration -- TAG model, dynamic meeting views
  --
  -- Tag conventions:
  --   <name>  -> a recurring meeting, identified by FILETAGS of
  --             ~/org/meetings/<name>.org. A 1:1 is just a meeting whose name is
  --             a person; tag that name on an item anywhere (e.g. a task you owe
  --             someone, raised in another meeting) to surface it in their view.
  --
  -- FILETAGS carry IDENTITY ONLY. So:
  --   #+FILETAGS: alice         (alice's 1:1 file)
  --   #+FILETAGS: staff         (staff meeting file)
  -- Items you record then take a TODO state (the "discuss vs do" axis is the
  -- STATE itself, not a tag):
  --   * AGND ...        a topic to RAISE  -> "Discuss" + that meeting's view
  --   * NEXT/TODO ...   your action       -> "Do now" + that meeting's view
  --   * WAIT ...        delegated         -> "Waiting" + that meeting's view
  -- AGND is its own keyword (a discussion point is a distinct thing, never also a
  -- tracked action); the custom agenda views give it its own block, so it no
  -- longer needs to be first in org_todo_keywords to surface. Add a
  -- keyworded item with <S-CR> (new heading) then a snippet from snippets/org.json:
  -- type t/a/w + <C-j> for TODO/AGND/WAIT.

  local org = require("orgmode")

  -- Todo-keyword colors derived from the CURRENT theme's Diagnostic groups, so
  -- they track colorscheme switches. Recomputed (and re-applied) on ColorScheme
  -- via setup_org_hl_groups below.
  local function org_todo_faces()
    local fg = function(group) return string.format("#%06x", Config.get_hl(group).fg) end
    return {
      AGND = ":weight bold :foreground " .. fg("DiagnosticInfo"),
      NEXT = ":weight bold :foreground " .. fg("DiagnosticError"),
      TODO = ":weight bold :foreground " .. fg("DiagnosticWarn"),
      WAIT = ":weight bold :foreground " .. fg("DiagnosticHint"),
      DONE = ":weight bold :foreground " .. fg("DiagnosticUnnecessary"),
      CNCL = ":weight bold :foreground " .. fg("DiagnosticUnnecessary"),
    }
  end

  org.setup({
    org_agenda_files = { "~/org/**/*" },
    org_default_notes_file = "~/org/tasks.org",

    -- Start week on Sunday in calendar widtget and agenda time grid views.
    calendar_week_start_day = 0,
    org_agenda_start_on_weekday = 0,
    org_agenda_block_separator = "",

    -- Disable org's buffer-local Insert <CR> (org_return). It has an upstream bug
    -- (it vim.eval's the global mini.keymap <CR> expr map -> "E15"), and we don't
    -- need it: our global <CR> handles newlines/popup, and <S-CR> owns structural
    -- Enter (calling org_mappings:org_return() as a method, still available). This
    -- lets the global <CR> apply in org buffers -- no buffer-local copy needed.
    mappings = { org = { org_return = false } },

    -- 4-char keywords for consistent-width badges. List order no longer drives
    -- retrieval: the custom agenda views now split each state into its own
    -- block, so the old 'todo-state-up' float (which needed AGND first) is moot.
    -- Order now only sets the fast-access menu order; TODO leads as the everyday
    -- default, AGND trails as the odd-one-out (a discussion point, never a
    -- tracked action). Reset target for repeating tasks is pinned explicitly
    -- below (org_todo_repeat_to_state), NOT inferred from this order.
    org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w)", "AGND(a)", "|", "DONE(d)", "CNCL(c)" },
    org_todo_keyword_faces = org_todo_faces(),
    -- When a repeating task (SCHEDULED/DEADLINE with a +N repeater) is marked
    -- DONE, org advances the date and resets the keyword. WITHOUT this, it resets
    -- to the first TODO-type keyword in the list (see TodoState:get_reset_todo) --
    -- which would land on whatever leads org_todo_keywords. Pin it to TODO so a
    -- recurrence comes back for re-triage in planning, never auto-promoted to
    -- NEXT and never (the old bug) flipped to AGND.
    org_todo_repeat_to_state = "TODO",
    org_deadline_warning_days = 7,
    org_log_into_drawer = "LOGBOOK",
    org_blank_before_new_entry = { heading = false, plain_list_item = false },
    -- org_use_tag_inheritance = true  -- default; filetags flow to headlines

    -- Heading aesthetics (native, no plugin):
    org_hide_leading_stars = true, -- show only the last star per heading
    org_startup_indented = true, -- virtual-indent content under its heading
    org_ellipsis = " ⤵", -- nicer fold marker than '...'
    -- org_hide_emphasis_markers = true, -- hide the * / / _ around bold/italic

    -- Tag alignment, applied when org aligns tags (e.g. <leader>ot / set-tags):
    -- NEGATIVE = right-align so tags END at column |value| (default -80).
    -- POSITIVE = tags START at that absolute column.
    -- Lower the magnitude to pull tags closer to the title (e.g. -60).
    org_tags_column = 0,

    -- Quick-capture for when you're NOT already typing in a meeting file.
    -- Lands in tasks.org and stays there -- no refiling. Location is irrelevant
    -- to retrieval; the agenda finds it by TODO state + tags wherever it lives.
    -- If a capture belongs to a person/meeting, add that tag in the capture
    -- buffer with <leader>ot before finalizing (that's tagging, not refiling).
    org_capture_templates = {
      -- No %a backlink: nvim-orgmode's %a is a bare [[file:PATH::LINE]] (line
      -- number only, no headline/ID search), which rots immediately in our
      -- newest-at-top meeting files. Retrieval here is positional-independent
      -- anyway -- found by TODO state + tags wherever the item lives -- so the
      -- durable pointer is a tag (add one with <leader>ot), not a file::line.
      t = { description = "Task", template = "* TODO %?", target = "~/org/tasks.org", headline = "Tasks" },
      -- Agenda item. Add the meeting/person tag in the capture buffer with
      -- <leader>ot (native org_set_tags, which completes against the live tag
      -- list) before finalizing. Top-level -- found by AGND + tag anywhere.
      a = {
        description = "Agenda item",
        template = "* AGND %?",
        target = "~/org/tasks.org",
      },
      -- Scheduled / recurring task: a dated TODO. %^t opens the calendar widget;
      -- for a recurring task, add a repeater (e.g. +1w / +1m) inside the <> in the
      -- capture buffer before finalizing. (One template covers both.)
      s = {
        description = "Scheduled task",
        template = "* TODO %?\nSCHEDULED: %^t",
        target = "~/org/tasks.org",
        headline = "Tasks",
      },
      -- Deadline task: due-by date. Shows with a lead-in warning in the agenda
      -- (org_deadline_warning_days) and in the weekly review (r).
      d = {
        description = "Deadline task",
        template = "* TODO %?\nDEADLINE: %^t",
        target = "~/org/tasks.org",
        headline = "Tasks",
      },
      -- Calendar event: a birthday / anniversary / holiday. A plain heading (NO
      -- todo keyword) with the active timestamp ON the heading line; %^t picks the
      -- date, add +1y in the buffer for the usual yearly recurrence. No tag needed.
      -- These collect under "* Events" in calendar.org -- open that file to view
      -- them (also surfaced in the agenda time grid when within its span).
      c = {
        description = "Calendar event",
        template = "* %? %^t",
        target = "~/org/calendar.org",
        headline = "Events",
      },
    },

    org_agenda_custom_commands = {
      -- DAILY LIST VIEW: This is the view I use throughout the day after I've
      -- identified the NEXT items from my planning view.
      d = {
        description = "Daily list",
        types = {
          { type = "agenda", org_agenda_span = "day", org_agenda_overriding_header = "Today" },
          {
            type = "tags_todo",
            match = "/NEXT",
            org_agenda_todo_ignore_deadlines = "far",
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do now",
          },
        },
      },

      -- DAILY PLANNING VIEW: I use this every morning to identify the tasks
      -- I want to do today by changing them from TODO to NEXT.
      p = {
        description = "Daily planning",
        types = {
          { type = "agenda", org_agenda_span = "week", org_agenda_overriding_header = "Week" },
          {
            type = "tags_todo",
            match = "/NEXT",
            org_agenda_todo_ignore_deadlines = "far",
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do now",
          },
          {
            type = "tags_todo",
            match = "/TODO",
            org_agenda_todo_ignore_deadlines = "far",
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do later",
          },
        },
      },

      -- WEEKLY REVIEW: I use this every week to review everything including
      -- WAIT and AGND task.
      r = {
        description = "Weekly review",
        types = {
          { type = "agenda", org_agenda_span = 14, org_agenda_overriding_header = "Next 2 weeks" },
          {
            type = "tags_todo",
            match = "/NEXT",
            org_agenda_todo_ignore_deadlines = "far",
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do now",
          },
          {
            type = "tags_todo",
            match = "/TODO",
            org_agenda_todo_ignore_deadlines = "far",
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do later",
          },
          {
            type = "tags_todo",
            match = "/WAIT",
            org_agenda_overriding_header = "Waiting / delegated",
          },
          {
            type = "tags_todo",
            match = "/AGND",
            org_agenda_overriding_header = "Discuss",
          },
        },
      },

      -- MEETING VIEW: every open item split into the three states, with NO date
      -- filtering so the whole backlog sits in the buffer. Press / in the agenda
      -- to filter by a person/meeting tag -- completion is over the tags actually
      -- present in the buffer (case-sensitive). Replaces the old <leader>oM
      -- MiniPick picker: same three sections, but pure built-in. Open via the
      -- agenda menu (<leader>oa -> v), then / to filter. Priority-sorted within
      -- each section.
      v = {
        description = "Meeting view",
        types = {
          {
            type = "tags_todo",
            match = "/AGND",
            org_agenda_sorting_strategy = { "priority-down" },
            org_agenda_overriding_header = "Discuss",
          },
          {
            type = "tags_todo",
            match = "/NEXT|TODO",
            org_agenda_sorting_strategy = { "priority-down" },
            org_agenda_overriding_header = "To do",
          },
          {
            type = "tags_todo",
            match = "/WAIT",
            org_agenda_sorting_strategy = { "priority-down" },
            org_agenda_overriding_header = "Waiting / delegated",
          },
        },
      },
    },
  })

  local setup_org_hl_groups = function()
    vim.api.nvim_set_hl(0, "@org.agenda.day", { link = "Question" })
    vim.api.nvim_set_hl(0, "@org.agenda.today", { link = "CursorLineNr" })
    vim.api.nvim_set_hl(0, "@org.agenda.scheduled", { link = "SpecialComment" })
    vim.api.nvim_set_hl(0, "@org.agenda.weekend.today", { link = "CursorLineNr" })
    vim.api.nvim_set_hl(0, "@org.agenda.header", { link = "MiniStarterSection" })
    vim.api.nvim_set_hl(0, "@org.agenda.tag", { link = "Special" })

    -- Refresh the todo-keyword faces from the new theme. org reads them from its
    -- config, so push fresh values with config:extend. Then re-apply -- but org
    -- applies faces with `hi default` (won't override a set group) AND its own
    -- ColorScheme handler re-defines them first, so clear the @org.keyword.face.*
    -- groups before re-defining or the old colors stick.
    local cfg = require("orgmode.config")
    cfg:extend({ org_todo_keyword_faces = org_todo_faces() })
    for keyword in pairs(cfg.org_todo_keyword_faces) do
      vim.cmd("highlight clear @org.keyword.face." .. keyword:gsub("%-", ""))
    end
    require("orgmode.colors.highlights").define_todo_keyword_faces()
  end

  setup_org_hl_groups()
  Config.new_autocmd("ColorScheme", {
    desc = "Tune the agenda tag hl group to point to Special.",
    callback = setup_org_hl_groups,
  })

  ----------------------------------------------------------------------------
  -- ICON HEADING BULLETS (optional plugin: nvim-orgmode/org-bullets.nvim).
  -- Replaces the visible star with a per-level icon. Combined with the native
  -- org_hide_leading_stars + org_startup_indented above, headings render as a
  -- single indented icon. Add the plugin to your plugin manager, e.g. lazy.nvim:
  --   { 'nvim-orgmode/orgmode', dependencies = { 'nvim-orgmode/org-bullets.nvim' } }
  -- The pcall keeps the config working even before the plugin is installed.
  local bullets = require("org-bullets")
  bullets.setup({
    concealcursor = true, -- keep the icon (not the raw stars) on the cursor line
    symbols = {
      -- one per heading level (cycles): * Meetings, ** date, *** note, ...
      headlines = { "◉", "○", "✸", "✿", "✤", "✜" },
      list = "•",
      checkboxes = {
        half = { "", "@org.checkbox.halfchecked" },
        done = { "✓", "@org.keyword.done" },
        todo = { "˟", "@org.keyword.todo" },
      },
    },
  })
end)

local ORG_ROOT = vim.fn.expand("~/org") .. "/"
local function org_rel(p) return (p:gsub("^" .. vim.pesc(ORG_ROOT), "")) end

-- CUSTOM ORG COMMANDS. Exposed as Config.org_* here and mapped globally in
-- plugin/core/13_mappings.lua under <leader>o. They work from any buffer; the
-- keys chosen there avoid the <leader>o<key> sequences org claims in org files
-- (e.g. org's buffer-local <leader>oe export -- hence new meeting entry is om).

----------------------------------------------------------------------------
-- OPEN ANY ORG FILE FROM ANYWHERE (MiniPick). builtin.files takes no glob
-- filter, so drive ripgrep through builtin.cli instead: --glob '*.org' lists
-- only org files -- which excludes *.org_archive (a different extension) -- and
-- rg emits paths relative to source.cwd, so the list reads as ~/org-relative
-- and mini.pick's default choose/preview open them for free.
Config.org_files = function()
  require("mini.pick").builtin.cli(
    { command = { "rg", "--files", "--glob", "*.org", "--color=never" } },
    { source = { name = "Org files", cwd = ORG_ROOT } }
  )
end

----------------------------------------------------------------------------
-- SEARCH ALL HEADLINES (MiniPick). Jump to any heading across every file.
-- Items carry path + lnum, so default choose jumps and preview shows context.
Config.org_headlines = function()
  local o = require("orgmode").instance()
  o.files:load() -- idempotent
  local items = {}
  for _, file in ipairs(o.files:all()) do
    local short = org_rel(file.filename)
    for _, h in ipairs(file:get_headlines()) do
      items[#items + 1] = {
        text = ("%s  %s"):format(short, h:get_title()),
        path = file.filename,
        lnum = h:get_range().start_line,
      }
    end
  end
  if vim.tbl_isempty(items) then return end
  require("mini.pick").start({ source = { name = "Org headlines", items = items } })
end

----------------------------------------------------------------------------
-- SEARCH ALL LINES (MiniPick live grep over ~/org, full text not just
-- headlines). Needs ripgrep, which mini.pick's grep uses.
Config.org_grep = function() require("mini.pick").builtin.grep_live({}, { source = { cwd = ORG_ROOT } }) end

----------------------------------------------------------------------------
-- TABLE EDITING. nvim-orgmode auto-realigns tables but ships NO cell-to-cell
-- motion (its <Tab>/<S-Tab> are fold cycling), and its Table:handle_cr() (row
-- insert) positions the cursor with a racy feedkeys('<Down>') + a separate
-- vim.schedule('norm! F|' .. '<Right><Right>') -- the two run on the event loop
-- with no ordering guarantee, so it doesn't reliably land in the first cell
-- (and the <Right>s are mode-sensitive -- our <S-CR> fires from Normal mode
-- too). These helpers do it deterministically by parsing the row's '|' columns
-- ourselves. A reformatted cell renders as "| value ", so a cell's content
-- starts 2 columns after its left '|': find('|') returns a 1-based byte index
-- and nvim cursor columns are 0-based, so that column is simply find('|') + 1.
-- Wired to <S-CR> (after/ftplugin/org.lua) and <Tab>/<S-Tab> (mini.keymap).
----------------------------------------------------------------------------

-- 1-based byte positions of every '|' on a line.
local function org_table_pipes(line)
  local t, i = {}, 0
  while true do
    i = line:find("|", i + 1, true)
    if not i then return t end
    t[#t + 1] = i
  end
end

-- Classify line `lnum`: nil if it is not a table row (or off the buffer), "hr"
-- for an hline separator (only pipes/dashes/pluses, e.g. |----+----|), else the
-- line text for a data row. getline() returns "" off the buffer ends, which is
-- not a table row, so this naturally stops at the table's top/bottom.
local function org_table_row(lnum)
  local line = vim.fn.getline(lnum)
  if not line:find("^%s*|") then return nil end
  if vim.trim(line):match("^|[-+|]+$") then return "hr" end
  return line
end

-- Nearest DATA row in direction `dir` (-1 up / +1 down) from `lnum`, skipping
-- hline separators; nil at the table edge. Used to wrap cell motion across rows.
local function org_table_data_row(lnum, dir)
  local l = lnum + dir
  while true do
    local kind = org_table_row(l)
    if kind == nil then return nil end
    if kind ~= "hr" then return l end
    l = l + dir
  end
end

-- Add a blank row below the current one, realign, and drop the cursor (in
-- Insert mode) into its first cell. Insert a bare '|' line: org's parser reads
-- it as a one-cell row joined to the table, so Table:reformat() pads it out to
-- the full column set. col('$') is passed so the table node is found whatever
-- the table's indent (mirrors org's own from_current_node default).
Config.org_table_new_row = function()
  local row = vim.fn.line(".")
  local indent = string.rep(" ", vim.fn.indent(row))
  vim.api.nvim_buf_set_lines(0, row, row, true, { indent .. "|" })
  local tbl = require("orgmode.files.elements.table").from_current_node({ row, vim.fn.col("$") })
  if tbl then tbl:reformat() end
  local newrow = row + 1
  local bar = (vim.api.nvim_buf_get_lines(0, newrow - 1, newrow, true)[1] or ""):find("|")
  vim.api.nvim_win_set_cursor(0, { newrow, bar and bar + 1 or 0 })
  vim.cmd("startinsert")
end

-- Move to the next cell (like Emacs <Tab>): at the end of a row, into the next
-- data row's FIRST cell; at the last cell of the last row, start a new row.
Config.org_table_next_cell = function()
  local col, ps = vim.api.nvim_win_get_cursor(0)[2], org_table_pipes(vim.api.nvim_get_current_line())
  local nextp
  for _, p in ipairs(ps) do
    if p - 1 > col then
      nextp = p
      break
    end
  end
  -- A cell to the right on this row (the last '|' is the right border, not a cell).
  if nextp and nextp ~= ps[#ps] then return vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), nextp + 1 }) end
  -- End of row: into the next data row's first cell, or a fresh row past the last.
  local nrow = org_table_data_row(vim.fn.line("."), 1)
  if not nrow then return Config.org_table_new_row() end
  local first = org_table_pipes(vim.fn.getline(nrow))[1]
  vim.api.nvim_win_set_cursor(0, { nrow, first and first + 1 or 0 })
end

-- Move to the previous cell (like Emacs <S-Tab>): at the start of a row, into
-- the previous data row's LAST cell; no-op at the very first cell of the table.
Config.org_table_prev_cell = function()
  local col, ps = vim.api.nvim_win_get_cursor(0)[2], org_table_pipes(vim.api.nvim_get_current_line())
  local idx
  for i = #ps, 1, -1 do
    if ps[i] - 1 < col then
      idx = i
      break
    end
  end
  -- A cell to the left on this row (idx 1 is the left border = already first cell).
  if idx and idx > 1 then return vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), ps[idx - 1] + 1 }) end
  -- Start of row: into the previous data row's last cell (2nd-to-last '|' = its border).
  local prow = org_table_data_row(vim.fn.line("."), -1)
  if not prow then return end
  local pps = org_table_pipes(vim.fn.getline(prow))
  if #pps >= 2 then vim.api.nvim_win_set_cursor(0, { prow, pps[#pps - 1] + 1 }) end
end

-- Tag vocabulary, top of e.g. ~/org/tasks.org:
--   #+TAGS: alice bob staff eng_sync project_x

----------------------------------------------------------------------------
-- FILE LAYOUT (convention)
--   ~/org/tasks.org            personal tasks (scheduled, recurring, captured)
--   ~/org/meetings/<name>.org  one per recurring meeting -- a person's 1:1 or a
--                              forum -- with #+FILETAGS: <name>
--   ~/org/adhoc.org            ad-hoc meetings   (tag the date heading :who:)
--   ~/org/projects/<name>.org  project notes/tasks
--
-- No inbox, no refiling: the agenda scans the whole tree and organizes by
-- TODO state + tags, so a task is found wherever it lives. Type items right
-- in the meeting file -- they inherit its identity tag, so your actions go to
-- "Do now", delegations to "Waiting", both still showing in that meeting's
-- view. Add :agenda: by hand only to a genuine thing-to-raise.
----------------------------------------------------------------------------

-- Open `path`, add today's dated entry as the first child of the top-level
-- "* Meetings" heading (creating that heading if absent), newest first, and
-- enter insert mode at the END of the date heading -- from there press <CR>/
-- <S-CR> for notes, or SPC + a name for an ad-hoc meeting.
local function start_entry(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local date_line = "** " .. os.date("%Y-%m-%d %a")

  -- locate the "* Meetings" top-level heading (with or without trailing tags)
  local meetings_at
  for i, line in ipairs(lines) do
    if line:match("^%*%s+Meetings%s*$") or line:match("^%*%s+Meetings%s+:") then
      meetings_at = i
      break
    end
  end

  local insert_at, new_lines
  if meetings_at then
    insert_at, new_lines = meetings_at, { date_line }
  else
    -- no Meetings heading yet: create it after the leading #+directives
    insert_at = 0
    for i, line in ipairs(lines) do
      if line:match("^%s*#%+") or line:match("^%s*$") then
        insert_at = i
      else
        break
      end
    end
    new_lines = { "* Meetings", date_line }
  end
  vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, new_lines)

  -- cursor on the date heading (last inserted line); startinsert! -> end of line
  vim.api.nvim_win_set_cursor(0, { insert_at + #new_lines, 0 })
  vim.cmd("startinsert!")
end

-- All recurring-meeting logs live in one folder; identity is just the file's
-- name (no person/forum distinction, no sigil).
local MEETINGS_DIR = vim.fn.expand("~/org/meetings")

-- Scaffold a brand-new meeting log (#+FILETAGS: <name>), then start its entry.
-- #+CATEGORY: meeting makes the agenda's left column read "meeting" (a type) for
-- every item here, instead of the filename -- the specific meeting is still shown
-- by its filetag.
local function new_log()
  vim.ui.input({ prompt = "Meeting name: " }, function(name)
    if not name or vim.trim(name) == "" then return end
    local slug = vim.trim(name):gsub("%s+", "_"):gsub("[^%w_]", "")
    if slug == "" then return vim.notify("Invalid name", vim.log.levels.WARN) end
    vim.fn.mkdir(MEETINGS_DIR, "p")
    local path = MEETINGS_DIR .. "/" .. slug .. ".org"
    if vim.fn.filereadable(path) == 0 then
      vim.fn.writefile(
        { "#+TITLE: " .. name, "#+CATEGORY: meeting", "#+FILETAGS: :" .. slug .. ":", "", "* Meetings" },
        path
      )
    end
    -- register with the running instance so it appears in the pickers/agenda
    -- immediately, without a restart or reload
    require("orgmode").instance().files:add_to_paths(path)
    start_entry(path)
  end)
end

-- NEW MEETING ENTRY: pick an existing meeting log -- or create one -- then
-- insert today's dated heading and start typing at once.
Config.org_new_meeting_entry = function()
  local items = { { text = "＋ New meeting log", is_new = true } } -- "New..." first
  -- vim.fs.dir is silent on a missing dir (unlike vim.fn.readdir, which prints
  -- "E484: Can't open file"), so MEETINGS_DIR not existing yet is a harmless
  -- no-op -- no guard needed. Filter by name only (not the yielded type) to
  -- stay symlink-tolerant: a symlinked log reports type "link", not "file".
  for name in vim.fs.dir(MEETINGS_DIR) do
    if name:match("%.org$") then
      local p = MEETINGS_DIR .. "/" .. name
      items[#items + 1] = { text = vim.fn.fnamemodify(p, ":t:r"), path = p }
    end
  end
  local adhoc = vim.fn.expand("~/org/adhoc.org")
  if vim.fn.filereadable(adhoc) == 1 then items[#items + 1] = { text = "Ad Hoc meeting", path = adhoc } end

  require("mini.pick").start({
    source = {
      name = "New meeting entry",
      items = items,
      choose = function(item)
        if not item then return end
        vim.schedule(function()
          if item.is_new then
            new_log()
          else
            start_entry(item.path)
          end
        end)
      end,
    },
  })
end

-- NOTE: org buffer-local mappings (<leader>it, <CR>, <S-CR>) live in
-- after/ftplugin/org.lua, which runs after orgmode's own ftplugin so it can
-- override org's buffer-local mappings without an autocmd or scheduling.
