-- ---------------------------------------------------------------------------
-- image
-- ---------------------------------------------------------------------------

MiniDeps.now(function()
  vim.pack.add({ "https://github.com/3rd/image.nvim" }, { load = true })
  require("image").setup()
end)
