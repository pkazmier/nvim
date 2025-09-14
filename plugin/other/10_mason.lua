MiniDeps.later(function()
  vim.pack.add({ "https://github.com/williamboman/mason.nvim" }, { load = true })
  require("mason").setup()
end)
