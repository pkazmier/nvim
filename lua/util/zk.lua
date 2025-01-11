local M = {}

function M.new_meeting(opts)
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
    local recent_notes = M.recent_meetings(notes, "title", opts.regex)
    local picker_opts = {
      title = "New Meeting",
      multi_select = false,
      snacks_picker = {
        win = {
          input = {
            keys = {
              ["<c-e>"] = { "new_note_from_input", mode = { "i", "n" } },
            },
          },
        },
        actions = {
          new_note_from_input = function(picker, item)
            picker:close()
            local title = picker.input.filter.pattern
            if title == "" then
              return
            end
            zk.new(vim.tbl_extend("keep", { title = title }, opts))
          end,
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
function M.recent_meetings(notes, field, regex)
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

return M
