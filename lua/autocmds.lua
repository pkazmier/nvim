-- Autocommands =============================================================
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("kaz-wrap-spell", { clear = true }),
  pattern = { "gitcommit", "markdown" },
  desc = "Enable spell/wrap based on filetype",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("kaz-disable-minianimate", { clear = true }),
  pattern = { "minifiles" },
  desc = "Disable animate in minifiles (preview goes bonkers)",
  callback = function()
    vim.b.minianimate_disable = true
  end,
})
