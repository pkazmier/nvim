-- ---------------------------------------------------------------------------
-- lume
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ { src = "https://github.com/danfry1/lume" } })
  require("catppuccin").setup({})
end)
