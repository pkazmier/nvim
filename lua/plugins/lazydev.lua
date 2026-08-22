-- ---------------------------------------------------------------------------
-- lazydev
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function()
  vim.pack.add({ { src = "https://github.com/folke/lazydev.nvim" } })
  require("lazydev").setup()
end)
