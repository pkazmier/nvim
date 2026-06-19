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

  org.setup({
    org_agenda_files = { "~/org/**/*" },
    org_default_notes_file = "~/org/tasks.org",

    -- 4-char keywords for consistent-width badges. List order sets the sort
    -- order under 'todo-state-up' (org has NO custom sort): AGND, NEXT, TODO,
    -- WAIT. AGND is first so it floats to the top of <leader>oM. The price of
    -- first place is that org's structural TODO inserts (iT/it, state-cycling)
    -- default to the first keyword = AGND -- moot here, since we add keyworded
    -- items via snippets (t/a/w + <C-j>), not org's default insert.
    org_todo_keywords = { "AGND(a)", "NEXT(n)", "TODO(t)", "WAIT(w)", "|", "DONE(d)", "CNCL(c)" },
    org_deadline_warning_days = 7,
    -- No blank line before a new heading -- lets <S-CR> bang out tight lists
    -- (insert your own blank lines when you want spacing).
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
      t = { description = "Task", template = "* TODO %?\n%a", target = "~/org/tasks.org", headline = "Tasks" },
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
      -- PERSONAL TODO LIST, two sections split by STATE. AGND items (discussion
      -- topics) collect under "Discuss" and stay out of "Do now" so nothing you
      -- must act on is buried under things you only mean to raise.
      w = {
        description = "Work list",
        types = {
          {
            type = "tags_todo",
            match = "/NEXT|TODO",
            org_agenda_todo_ignore_scheduled = "past", -- VERIFY on your machine
            org_agenda_overriding_header = "Do now",
            org_agenda_sorting_strategy = { "todo-state-up", "priority-down" },
          },
          {
            type = "tags_todo",
            match = "/AGND",
            org_agenda_overriding_header = "Discuss",
            org_agenda_sorting_strategy = { "category-up", "priority-down" },
          },
        },
      },

      d = {
        description = "Today",
        types = {
          { type = "agenda", org_agenda_span = "day", org_agenda_overriding_header = "Today" },
        },
      },

      g = {
        description = "Waiting / delegated",
        types = {
          {
            type = "tags_todo",
            match = "/WAIT",
            org_agenda_overriding_header = "Waiting on others",
            org_agenda_sorting_strategy = { "category-up" },
          },
        },
      },

      -- WEEKLY REVIEW: the next two weeks of dated commitments (scheduled items
      -- + deadlines leading in), then delegated items due for follow-up.
      --
      -- "Stale" follow-ups: nvim-orgmode does NOT timestamp WAIT transitions, so
      -- there's no automatic "days in WAIT". Instead, when you delegate, give the
      -- item a SCHEDULED follow-up date (when to chase it). This block then shows
      -- WAIT items whose follow-up is due (scheduled today or earlier) plus any
      -- WAIT with no date set -- and hides ones you've deferred to a future date.
      -- (For true age-based staleness, add a :DELEGATED: <date> property when you
      --  delegate and match e.g.  DELEGATED<="<-7d>"/WAIT  instead.)
      r = {
        description = "Weekly review",
        types = {
          {
            type = "agenda",
            org_agenda_span = 14,
            org_agenda_overriding_header = "Next 2 weeks (scheduled & deadlines)",
          },
          {
            type = "tags_todo",
            match = "/WAIT",
            org_agenda_todo_ignore_scheduled = "past", -- keep due/undated, hide deferred
            org_agenda_overriding_header = "Follow up (delegated)",
            org_agenda_sorting_strategy = { "category-up", "priority-down" },
          },
        },
      },
    },
  })

  ----------------------------------------------------------------------------
  -- ICON HEADING BULLETS (optional plugin: nvim-orgmode/org-bullets.nvim).
  -- Replaces the visible star with a per-level icon. Combined with the native
  -- org_hide_leading_stars + org_startup_indented above, headings render as a
  -- single indented icon. Add the plugin to your plugin manager, e.g. lazy.nvim:
  --   { 'nvim-orgmode/orgmode', dependencies = { 'nvim-orgmode/org-bullets.nvim' } }
  -- The pcall keeps the config working even before the plugin is installed.
  local ok_bullets, bullets = pcall(require, "org-bullets")
  if ok_bullets then
    bullets.setup({
      concealcursor = false, -- keep the icon while the cursor is on the line
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
  end

  local ORG_ROOT = vim.fn.expand("~/org") .. "/"
  local function org_rel(p) return (p:gsub("^" .. vim.pesc(ORG_ROOT), "")) end

  -- CUSTOM ORG COMMANDS. Exposed as Config.org_* here and mapped globally in
  -- plugin/core/13_mappings.lua under <leader>o. They work from any buffer; the
  -- keys chosen there avoid the <leader>o<key> sequences org claims in org files
  -- (e.g. org's buffer-local <leader>oe export -- hence new meeting entry is om).

  ----------------------------------------------------------------------------
  -- OPEN ITEMS BY TAG (MiniPick). One picker over every tag; pick one (a meeting,
  -- a project...) to list all open items carrying it. AGND (discussion topics)
  -- float to the top via todo-state-up -- your meeting-prep list.
  ----------------------------------------------------------------------------
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
            o.agenda:tags_todo({
              match_query = tag,
              todo_only = true,
              header = "Open items: " .. tag,
              sorting_strategy = { "todo-state-up", "priority-down" },
            })
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

  -- Open `path`, add today's dated entry UNDER the top-level "* Meetings"
  -- heading (creating that heading if absent), newest first, and drop the
  -- cursor into a child line in insert mode -- ready to type immediately.
  local function start_entry(path)
    vim.cmd("edit " .. vim.fn.fnameescape(path))
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local date = os.date("%Y-%m-%d %a")

    -- locate the "* Meetings" top-level heading (with or without trailing tags)
    local meetings_at
    for i, line in ipairs(lines) do
      if line:match("^%*%s+Meetings%s*$") or line:match("^%*%s+Meetings%s+:") then
        meetings_at = i
        break
      end
    end

    local row
    if meetings_at then
      -- new dated entry as the first child of Meetings (level 2 + level 3 note)
      vim.api.nvim_buf_set_lines(0, meetings_at, meetings_at, false, { "** " .. date, "*** " })
      row = meetings_at + 2
    else
      -- no Meetings heading yet: create it after the leading #+directives
      local at = 0
      for i, line in ipairs(lines) do
        if line:match("^%s*#%+") or line:match("^%s*$") then
          at = i
        else
          break
        end
      end
      vim.api.nvim_buf_set_lines(0, at, at, false, { "* Meetings", "** " .. date, "*** " })
      row = at + 3
    end
    vim.api.nvim_win_set_cursor(0, { row, 4 }) -- end of the '*** ' note line
    vim.cmd("startinsert!")
  end

  -- All recurring-meeting logs live in one folder; identity is just the file's
  -- name (no person/forum distinction, no sigil).
  local MEETINGS_DIR = vim.fn.expand("~/org/meetings")

  -- Scaffold a brand-new meeting log (#+FILETAGS: <name>), then start its entry.
  local function new_log()
    vim.ui.input({ prompt = "Meeting name: " }, function(name)
      if not name or vim.trim(name) == "" then return end
      local slug = vim.trim(name):gsub("%s+", "_"):gsub("[^%w_]", "")
      if slug == "" then return vim.notify("Invalid name", vim.log.levels.WARN) end
      vim.fn.mkdir(MEETINGS_DIR, "p")
      local path = MEETINGS_DIR .. "/" .. slug .. ".org"
      if vim.fn.filereadable(path) == 0 then
        vim.fn.writefile({ "#+TITLE: " .. name, "#+FILETAGS: :" .. slug .. ":", "", "* Meetings" }, path)
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
end)
