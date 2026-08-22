-- ---------------------------------------------------------------------------
-- mini.cursorword
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

local M = {}

-- Toggle function, which is bound to '\W' in keymaps
function M.toggle()
  vim.g.minicursorword_disable = not vim.g.minicursorword_disable
  vim.cmd("doautocmd CursorMoved")
end

loader.later(function() require("mini.cursorword").setup() end)

return M
