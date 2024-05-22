require("mini.git").setup({})

local align_blame = function(au_data)
  if au_data.data.git_subcommand ~= "blame" then
    return
  end

  -- Align blame output with source
  local win_src = au_data.data.win_source
  vim.wo.wrap = false
  vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
  vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

  -- Bind both windows so that they scroll together
  vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

local group = vim.api.nvim_create_augroup("kaz-minigit", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MiniGitCommandSplit",
  callback = align_blame,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group,
  pattern = { "git", "diff" },
  desc = "Set fold configuration for mini.git",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
  end,
})
