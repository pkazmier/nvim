MiniDeps.now(function()
  local pad = function(str, n)
    return string.rep(" ", n) .. str
  end

  -- Function from [echasnovski](https://github.com/echasnovski/nvim).
  local greeting = function()
    local hour = tonumber(vim.fn.strftime("%H"))
    -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
    local part_id = math.floor((hour + 4) / 8) + 1
    local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
    local username = vim.loop.os_get_passwd()["username"] or "USERNAME"
    return ("Good %s, %s"):format(day_part, username)
  end

  local fortune = function()
    local ok, quote = pcall(function()
      local f = assert(io.popen("fortune -s", "r"))
      local s = assert(f:read("*a"))
      f:close()
      return s
    end)
    return ok and quote or nil
  end

  local longest_line = function(s)
    local lines = vim.fn.split(s, "\n")
    local lengths = vim.tbl_map(vim.fn.strdisplaywidth, lines)
    return math.max(unpack(lengths))
  end

  local starter = require("mini.starter")
  starter.setup({
    -- Default values with exception of '-' as I use it to open mini.files.
    query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",

    -- stylua: ignore
    items = {
      starter.sections.sessions(5, true),
      starter.sections.recent_files(3, false, false),
      {
        { name = "Mason",          action = "Mason",                 section = "Updaters"},
        { name = "Update plugins", action = "lua vim.pack.update()", section = "Updaters"},
        { name = "New Meeting",    action = "ZkNewMeeting",          section = "Actions"},
        { name = "Visited files",  action = "Pick visit_paths",      section = "Actions"},
        { name = "Quit Neovim",    action = "qall",                  section = "Actions"},
      },
    },

    header = function()
      local banner = [[

                 █              █

████████████ ███ ████████ ███
██████████████ ████ ██████████ ████
█████ ████ █████ ████ █████ █████ ████
█████ ████ █████ ████ █████ █████ ████
█████ ████ ████████ █████ ████████
]]
      local msg = greeting()
      local msg_pad = longest_line(banner) - msg:len()
      return banner .. pad(msg, msg_pad)
    end,

    -- Fortune slows startup a small amount, but I like it.
    footer = fortune(),
  })
end)
