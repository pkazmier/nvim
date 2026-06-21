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
  -- tracked action), kept first in the list so it floats to the top of the
  -- by-tag view (<leader>oM) -- your meeting-prep list. Add a keyworded item with
  -- <S-CR> (new heading) then a snippet from snippets/org.json: type t/a/w + <C-j>
  -- for TODO/AGND/WAIT.

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

    -- Drop empty sections from any multi-block view -- the weekly review (r) and
    -- the by-tag view (<leader>oM). org skips a block's header+body when it has
    -- an `id` (true of every custom-command block, and we set one per by-tag
    -- block) and resolves to zero headlines. The time-grid `agenda` block is
    -- unaffected (no hide logic there) so the calendar always shows.
    org_agenda_hide_empty_blocks = true,

    -- Disable org's buffer-local Insert <CR> (org_return). It has an upstream bug
    -- (it vim.eval's the global mini.keymap <CR> expr map -> "E15"), and we don't
    -- need it: our global <CR> handles newlines/popup, and <S-CR> owns structural
    -- Enter (calling org_mappings:org_return() as a method, still available). This
    -- lets the global <CR> apply in org buffers -- no buffer-local copy needed.
    mappings = { org = { org_return = false } },

    -- 4-char keywords for consistent-width badges. List order sets the sort
    -- order under 'todo-state-up' (org has NO custom sort): AGND, NEXT, TODO,
    -- WAIT. AGND is first so it floats to the top of <leader>oM. The price of
    -- first place is that org's structural TODO inserts (iT/it, state-cycling)
    -- default to the first keyword = AGND -- moot here, since we add keyworded
    -- items via snippets (t/a/w + <C-j>), not org's default insert.
    org_todo_keywords = { "AGND(a)", "NEXT(n)", "TODO(t)", "WAIT(w)", "|", "DONE(d)", "CNCL(c)" },
    org_todo_keyword_faces = org_todo_faces(),
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
      -- Agenda item. %(...) runs at capture time and fuzzy-picks the tag from the
      -- live tag list via a synchronous MiniPick (see Config.org_agenda_tag, which
      -- returns ":tag:" or ""). Top-level -- found by AGND + tag anywhere.
      a = {
        description = "Agenda item",
        template = "* AGND %? %(return Config.org_agenda_tag())",
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
      -- date, add +1y in the buffer for the usual yearly recurrence. No tag needed
      -- -- Config.org_events() (<leader>oE) finds events structurally (no-todo
      -- headline + plain active timestamp).
      c = {
        description = "Calendar event",
        template = "* %? %^t",
        target = "~/org/calendar.org",
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
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do now",
          },
          {
            type = "tags_todo",
            match = "/TODO",
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
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do now",
          },
          {
            type = "tags_todo",
            match = "/TODO",
            org_agenda_todo_ignore_scheduled = "past",
            org_agenda_overriding_header = "Do later",
          },
          {
            type = "tags_todo",
            match = "/WAIT",
            org_agenda_overriding_header = "Waiting / Delegate ",
          },
          {
            type = "tags_todo",
            match = "/AGND",
            org_agenda_overriding_header = "Discuss",
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
-- OPEN ITEMS BY TAG (MiniPick). One picker over every tag; pick one (a meeting,
-- a project...) to see all open items carrying it, SPLIT into sections -- AGND
-- to discuss, WAIT delegated, NEXT/TODO to do -- like the custom agenda views.
--
-- A single agenda:tags_todo() call goes through Agenda:open_view, which forces
-- self.views to one view. The multi-section custom commands instead build
-- several view objects and assign them all to agenda.views before rendering
-- (see Agenda:_build_custom_commands upstream). We do the same here, only the
-- match query (and thus the tag) is chosen dynamically. The query syntax is
-- "tag/STATE"; '|' ORs todo states, so "<tag>/NEXT|TODO" is one section.
----------------------------------------------------------------------------
local ORG_TAG_SECTIONS = {
  { suffix = "/AGND", header = "Discuss" },
  { suffix = "/NEXT|TODO", header = "To do" },
  { suffix = "/WAIT", header = "Waiting / Delegated" },
}

Config.org_items_by_tag = function()
  local o = require("orgmode").instance()
  o.files:load() -- idempotent; ensures the tag list is populated
  local items = o.files:get_tags()
  if vim.tbl_isempty(items) then return vim.notify("No tags found", vim.log.levels.WARN) end
  require("mini.pick").start({
    source = {
      name = "Open items by tag",
      items = items,
      choose = function(tag)
        if not tag then return end
        vim.schedule(function() -- run after the picker closes
          local agenda = o.agenda
          local AgendaTypes = require("orgmode.agenda.types")
          local views = {}
          for i, section in ipairs(ORG_TAG_SECTIONS) do
            -- id set => prepare()/redraw() skip the interactive "Match:" prompt
            -- (these are fixed custom views); files/filters/highlighter are the
            -- per-instance objects open_view would otherwise inject for us.
            views[#views + 1] = AgendaTypes.tags_todo:new({
              match_query = tag .. section.suffix,
              todo_only = true,
              header = ("%s: %s"):format(section.header, tag),
              id = ("org_items_by_tag_%d"):format(i),
              files = agenda.files,
              agenda_filter = agenda.filters,
              highlighter = agenda.highlighter,
              sorting_strategy = { "priority-down" },
            })
          end
          agenda.views = views
          agenda:prepare_and_render()
        end)
      end,
    },
  })
end

----------------------------------------------------------------------------
-- AGENDA ITEM CAPTURE. The `a` capture template (in org_capture_templates) is
-- `* AGND %? %(return Config.org_agenda_tag())`. A capture template can't run an
-- ASYNC picker, but MiniPick.start() is SYNCHRONOUS -- it blocks and returns the
-- chosen item -- so it works inside the template's %(...) expansion. A no-op
-- `choose` makes start() just return the item (no default file-open). Returns
-- ":tag:" or "" (cancelled). Reached via the capture menu (<leader>oc -> a).
----------------------------------------------------------------------------
Config.org_agenda_tag = function()
  local o = require("orgmode").instance()
  o.files:load() -- idempotent; populates the tag list
  local tags = o.files:get_tags()
  if vim.tbl_isempty(tags) then return "" end
  local tag = require("mini.pick").start({
    source = { name = "Agenda item: tag", items = tags, choose = function() end },
  })
  return (tag and tag ~= "") and (":" .. tag .. ":") or ""
end

----------------------------------------------------------------------------
-- OPEN ANY ORG FILE FROM ANYWHERE (MiniPick).
-- Items carry the absolute `path`, so mini.pick's default choose/preview open
-- and preview the file for free; `text` shows the path relative to ~/org.
Config.org_files = function()
  local o = require("orgmode").instance()
  o.files:load() -- idempotent
  local items = {}
  for _, p in ipairs(o.files:filenames()) do
    items[#items + 1] = { text = org_rel(p), path = p }
  end
  if vim.tbl_isempty(items) then return end
  require("mini.pick").start({ source = { name = "Org files", items = items } })
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

----------------------------------------------------------------------------
-- EVENTS (MiniPick), date-sorted. A flat list of every recurring/dated EVENT
-- across all files -- defined STRUCTURALLY, no tag required: a headline with NO
-- todo keyword carrying a plain active timestamp. Birthdays/anniversaries/
-- appointments use a bare <date>; tasks use SCHEDULED/DEADLINE, so they're
-- excluded (date:is_none() keeps only active type-NONE stamps). Sorted by next
-- upcoming occurrence so the soonest is on top. This is the events view a
-- year-span time-grid can't give (org has no entry-type filter for plain dates).
----------------------------------------------------------------------------
Config.org_events = function()
  local o = require("orgmode").instance()
  o.files:load() -- idempotent
  -- next occurrence (today or later) of a yearly event, as a sortable time
  local function next_occ(ts)
    local d, t = os.date("*t", ts), os.date("*t")
    local today = os.time({ year = t.year, month = t.month, day = t.day })
    local cand = os.time({ year = t.year, month = d.month, day = d.day })
    if cand < today then cand = os.time({ year = t.year + 1, month = d.month, day = d.day }) end
    return cand
  end
  local items = {}
  for _, file in ipairs(o.files:all()) do
    local short = org_rel(file.filename)
    for _, h in ipairs(file:get_headlines()) do
      if not h:get_todo() then -- events carry no todo keyword
        for _, date in ipairs(h:get_all_dates()) do
          if date:is_none() then -- plain ACTIVE timestamp (excludes SCHEDULED/DEADLINE)
            local nxt = next_occ(date.timestamp)
            -- strip a trailing <timestamp> from the title (events keep the date
            -- on the heading line, so get_title includes it)
            local title = h:get_title():gsub("%s*<[^>]*>%s*$", "")
            items[#items + 1] = {
              text = ("%s  %s  (%s)"):format(os.date("%Y-%m-%d %a", nxt), title, short),
              path = file.filename,
              lnum = h:get_range().start_line,
              _next = nxt,
            }
            break -- one row per headline
          end
        end
      end
    end
  end
  if vim.tbl_isempty(items) then return vim.notify("No events found", vim.log.levels.WARN) end
  table.sort(items, function(a, b) return a._next < b._next end)
  require("mini.pick").start({ source = { name = "Events (next first)", items = items } })
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
