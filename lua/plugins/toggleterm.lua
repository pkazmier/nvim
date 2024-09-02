M = {}

local Terminal = require("toggleterm.terminal").Terminal

M.lazygit_toggle = function()
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "tab",
  })
  lazygit:toggle()
end

require("toggleterm").setup({
  open_mapping = [[<c-\>]],
})

return M
