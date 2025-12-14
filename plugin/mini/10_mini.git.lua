-- ---------------------------------------------------------------------------
-- mini.git
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  require("mini.git").setup({})

  Config.new_autocmd({ "FileType" }, {
    pattern = { "git", "diff" },
    desc = "Set fold configuration for mini.git",
    callback = function()
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
    end,
  })

  local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s\%d\ [\%an] --graph --all]]

  Config.minigit_log = function() vim.cmd(git_log_cmd) end

  Config.minigit_log_buf = function() vim.cmd(git_log_cmd .. " --follow -- %") end
end)
