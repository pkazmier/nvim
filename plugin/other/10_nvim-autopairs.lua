MiniDeps.later(function()
  vim.pack.add({ "https://github.com/windwp/nvim-autopairs" }, { load = true })
  require("nvim-autopairs").setup({
    map_cr = false,
    map_bs = false,
  })
end)
