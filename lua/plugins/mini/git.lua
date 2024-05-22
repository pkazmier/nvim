require("mini.git").setup({})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("kaz-git-folds", { clear = true }),
  pattern = { "git", "diff" },
  desc = "Set fold configuration for mini.git",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
  end,
})
