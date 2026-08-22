-- ---------------------------------------------------------------------------
-- mason
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now_if_args(function()
  vim.pack.add({ { src = "https://github.com/williamboman/mason.nvim" } })
  require("mason").setup()
end)
