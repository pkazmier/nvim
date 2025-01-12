-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.ai_cmp = false
vim.g.kaz_transparency = false
vim.g.lazyvim_python_lsp = "basedpyright"

vim.opt.cursorlineopt = vim.g.kaz_transparency and "number" or "both"
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
vim.opt.textwidth = 76
