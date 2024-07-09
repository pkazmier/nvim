require("mini.indentscope").setup({})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "dashboard",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
