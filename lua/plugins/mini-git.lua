-- ---------------------------------------------------------------------------
-- mini.git
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")

local M = {}

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s\%d\ [\%an] --graph --all]]

function M.log() vim.cmd(git_log_cmd) end

function M.log_buf() vim.cmd(git_log_cmd .. " --follow -- %") end

loader.later(function()
  require("mini.git").setup({})

  autocmds.new("FileType", {
    pattern = { "git", "diff" },
    desc = "Set fold configuration for mini.git",
    callback = function()
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
    end,
  })
end)

return M
