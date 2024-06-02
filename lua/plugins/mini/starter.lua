local H = {}
local starter = require("mini.starter")

starter.setup({
  -- Default values with exception of '-' as I use it to open mini.files.
  query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",

  -- stylua: ignore
  items = {
    starter.sections.sessions(5, true),
    starter.sections.recent_files(3, false, false),
    {
      { name = "Mason",         action = "Mason",            section = "Updaters"},
      { name = "Update deps",   action = "DepsUpdate",       section = "Updaters"},
      { name = "New buffer",    action = "enew",             section = "Builtin actions"},
      { name = "Visited files", action = "Pick visit_paths", section = "Builtin actions"},
      { name = "Quit Neovim",   action = "qall",             section = "Builtin actions"},
    },
  },

  header = function()
    local banner = [[

      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████

  ]]
    local msg = H.greeting()
    local n = math.floor((70 - msg:len()) / 2)
    return banner .. H.pad(msg, n)
  end,

  -- Fortune slows startup by about 10ms ... ugh
  -- footer = function()
  --   local ok, quote = pcall(H.fortune)
  --   return ok and quote or nil
  -- end,
  footer = "",
})

H.pad = function(str, n)
  return string.rep(" ", n) .. str
end

H.greeting = function()
  local hour = tonumber(vim.fn.strftime("%H"))
  -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
  local part_id = math.floor((hour + 4) / 8) + 1
  local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
  local username = vim.loop.os_get_passwd()["username"] or "USERNAME"

  return ("Good %s, %s"):format(day_part, username)
end

H.fortune = function()
  local f = assert(io.popen("fortune -s", "r"))
  local s = assert(f:read("*a"))
  f:close()
  return s
end
