MiniDeps.later(function()
  require("mini.cursorword").setup()

  Config.minicursorword_toggle = function()
    vim.g.minicursorword_disable = not vim.g.minicursorword_disable
    vim.cmd("doautocmd CursorMoved")
  end
end)
