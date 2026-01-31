-- ---------------------------------------------------------------------------
-- lazydev
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
  require("lazydev").setup()
end)
