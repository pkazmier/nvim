-- ---------------------------------------------------------------------------
-- zk-nvim (my note taking system)
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

local H = {}

loader.now(function()
  vim.pack.add({ { src = "https://github.com/zk-org/zk-nvim" } })
  local cmds = require("zk.commands")

  require("zk").setup({
    picker = "minipick",
    lsp = {
      config = { cmd = { "zk", "lsp" }, name = "zk" },
      auto_attach = { enabled = true, filetypes = { "markdown" } },
    },
  })

  cmds.add("ZkNewMeeting", function(opts)
    opts = vim.tbl_extend("force", { dir = "meetings" }, opts or {})
    H.new_meeting(opts)
  end)

  cmds.add("ZkLiveSearch", function(opts) H.live_search(opts) end)

  cmds.add("ZkPriorMeetings", function(_)
    local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)
    if #line == 1 then
      local meeting = line[1]:match("^# %d%d%d%d%-%d%d%-%d%d: (.+)")
      if meeting then
        cmds.get("ZkNotes")({
          excludeHrefs = { vim.api.nvim_buf_get_name(0) },
          sort = { "created" },
          match = { 'title: "' .. meeting .. '"' },
        })
      end
    end
  end)
end)

-- Namespace for the dimmed body-snippet extmarks in H.live_search's picker.
local snippet_ns = vim.api.nvim_create_namespace("zk_live_search_snippet")

-- Force EXACT matching, unless the user typed a mode prefix themselves (see
-- |MiniPick-matching|: ' exact, ^ exact-at-start, * forced fuzzy). Fuzzy across
-- whole note bodies matches very nearly everything, which is what zk's
-- `fzf --exact` avoids.
H.live_match = function(stritems, inds, query)
  local first = query[1]
  if first ~= "'" and first ~= "^" and first ~= "*" then query = vim.list_extend({ "'" }, query) end
  return require("mini.pick").default_match(stritems, inds, query)
end

-- Render "title  body-snippet" with the snippet dimmed, rather than the raw
-- match haystack that item.text holds. Mirrors zk's fzf line, where the title
-- is styled and the body trails it in `understate`.
H.live_show = function(buf_id, items, query)
  local lines, title_len = {}, {}
  for i, item in ipairs(items) do
    title_len[i] = #item.title
    lines[i] = item.body == "" and item.title or (item.title .. "  " .. item.body)
  end

  require("mini.pick").default_show(buf_id, lines, query)

  -- Read the lines back: default_show rewrites them (tabs expanded, NULs
  -- replaced), so byte columns must come from the buffer, not from `lines`.
  vim.api.nvim_buf_clear_namespace(buf_id, snippet_ns, 0, -1)
  local shown = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  for i, line in ipairs(shown) do
    local from = title_len[i]
    if from and from < #line then
      vim.api.nvim_buf_set_extmark(buf_id, snippet_ns, i - 1, from, {
        end_row = i - 1,
        end_col = #line,
        hl_group = "Comment",
        priority = 10,
      })
    end
  end
end

-- INCREMENTAL FULL-TEXT SEARCH over every note -- the in-editor equivalent of
-- `zk edit -i`, which zk-nvim does not provide: all of its pickers match note
-- TITLES only (zk/pickers/minipick.lua sets `text = note.title or note.path`),
-- and ZkMatch takes its query once up front rather than incrementally.
--
-- The CLI flow works because zk's default fzf-line template is
--   {{style "title" title-or-path}} {{style "understate" body}} {{...metadata}}
-- i.e. the WHOLE body rides on each fzf line, dimmed, and zk runs fzf with
-- --exact. fzf matches the entire line, so its incremental filter spans full
-- text. This reproduces that in mini.pick:
--
--   * one `zk list` pulls every body out of the SQLite index -- a single DB
--     read, not a walk over the notebook, which is why it stays cheap on a
--     large notebook (and on a machine with slow file I/O);
--   * each item's match haystack is "title .. body" (title first, so a title
--     hit outranks a body hit -- mini.pick's sort favours earlier matches, the
--     same effect as zk's `--tiebreak begin`);
--   * matching is forced EXACT, since fuzzy across whole bodies matches very
--     nearly everything. That is precisely what zk's --exact avoids. An
--     explicit mode prefix the user types ('/^/*) is left alone;
--   * the list SHOWS the title plus a dimmed body snippet, so a body-only hit
--     still shows why it matched (zk shows the body for the same reason).
H.live_search = function(opts)
  local api = require("zk.api")

  opts = vim.tbl_extend("force", {
    select = { "title", "absPath", "body" },
    sort = { "modified" },
  }, opts or {})

  api.list(opts.notebook_path, opts, function(err, notes)
    assert(not err, tostring(err))

    local items = {}
    for _, note in ipairs(notes) do
      -- Flatten whitespace in the title too, not just the body: display columns
      -- for the dim extmark are byte offsets, and a tab in a title would be one
      -- byte here but tabstop-many spaces once default_show expands it.
      local title = vim.trim((note.title or vim.fn.fnamemodify(note.absPath, ":t:r")):gsub("%s+", " "))
      local body = vim.trim((note.body or ""):gsub("%s+", " "))
      table.insert(items, {
        text = body == "" and title or (title .. " " .. body),
        path = note.absPath,
        title = title,
        body = body,
      })
    end

    if vim.tbl_isempty(items) then
      vim.notify("No notes found", vim.log.levels.WARN)
      return
    end

    require("mini.pick").start({
      source = {
        name = "Zk Full Text",
        items = items,
        match = H.live_match,
        show = H.live_show,
      },
    })
  end)
end

H.new_meeting = function(opts)
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
              if query == nil then return true end
              zk.new(vim.tbl_extend("keep", { title = table.concat(query, "") }, opts))
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
