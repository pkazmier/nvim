-- ---------------------------------------------------------------------------
-- mini.starter
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

-- local banner = [[
--                   █                █
--
-- ████████████  ███  ████████  ███
-- ██████████████  ████  ██████████  ████
-- █████ ████ █████  ████  █████ █████  ████
-- █████ ████ █████ ███  █████ █████ ███
-- ]]

local banner = [[

     │ ╲ ││  ╲    ╱  ││   │ ╲  ╱ │
     ││╲╲││   ╲╲╱╱   ││   ││╲╲╱╱││
     ││ ╲ │    ╲╱    ││   ││ ╲╱ ││
]]

loader.now(function()
  local starter = require("mini.starter")

  local fortune = function()
    local ok, result = pcall(function()
      local f = assert(io.popen("fortune -s | fmt 38", "r"))
      local s = assert(f:read("*a"))
      f:close()
      return s
    end)
    return ok and result or nil
  end

  starter.setup({
    -- stylua: ignore
    items = {
      starter.sections.sessions(3, true),
      starter.sections.recent_files(3, false, false),
      {
        { name = "Mason",          action = "Mason",                  section = "Actions" },
        { name = "Update plugins", action = "lua vim.pack.update()",  section = "Actions" },
        { name = "Visited files",  action = "Pick visit_paths",       section = "Actions" },
        { name = "Quit Neovim",    action = "qall",                   section = "Actions" },
      },
    },
    query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
    header = banner,
    footer = fortune,
  })
end)
