-- ---------------------------------------------------------------------------
-- copilot
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local options = require("config.options")

loader.later(function()
  if options.copilot_disable then return end

  vim.pack.add({ { src = "https://github.com/zbirenbaum/copilot.lua" } })
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end)
