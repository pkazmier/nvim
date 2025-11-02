-- ---------------------------------------------------------------------------
-- mini.cursorword
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  require("mini.cursorword").setup()

  -- Create toggle function, which is bound to '\W' in mappings
  Config.minicursorword_toggle = function()
    vim.g.minicursorword_disable = not vim.g.minicursorword_disable
    vim.cmd("doautocmd CursorMoved")
  end
end)
