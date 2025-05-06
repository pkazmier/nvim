vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=1")
