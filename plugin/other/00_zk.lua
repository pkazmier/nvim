local H = {}
MiniDeps.now(function()
  vim.pack.add({ "https://github.com/zk-org/zk-nvim" }, { load = true })
  local cmds = require("zk.commands")

  require("zk").setup({
    picker = "minipick",
    lsp = {
      config = {
        cmd = { "zk", "lsp" },
        name = "zk",
      },
      auto_attach = { enabled = true, filetypes = { "markdown" } },
    },
  })

  cmds.add("ZkNewMeeting", function(opts)
    opts = vim.tbl_extend("force", { dir = "meetings" }, opts or {})
    H.new_meeting(opts)
  end)

  cmds.add("ZkFullTextSearch", function(opts)
    opts = opts or {}
    if not opts.match then
      opts.match = { vim.fn.input("Match: ") }
    end
    opts = vim.tbl_extend("keep", opts, {
      sort = { "created" },
    })
    cmds.get("ZkNotes")(opts)
  end)

  cmds.add("ZkPriorMeetings", function(_)
    local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)
    if #line == 1 then
      local meeting = line[1]:match("^# %d%d%d%d%-%d%d%-%d%d: (.+)")
      if meeting then
        local filter = 'title: "' .. meeting .. '"'
        local bufname = vim.api.nvim_buf_get_name(0)
        cmds.get("ZkNotes")({
          excludeHrefs = { bufname },
          sort = { "created" },
          match = { filter },
        })
      end
    end
  end)

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
end)
