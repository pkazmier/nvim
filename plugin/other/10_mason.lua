-- ---------------------------------------------------------------------------
-- mason
-- ---------------------------------------------------------------------------

Config.now_if_args(function()
  vim.pack.add({ "https://github.com/williamboman/mason.nvim" }, { load = true })
  require("mason").setup()
end)
