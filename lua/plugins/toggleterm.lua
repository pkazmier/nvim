M = {}

local Terminal = require("toggleterm.terminal").Terminal

require("toggleterm").setup({
  open_mapping = [[<c-\>]],
  on_create = function(term)
    local opts = { buffer = term.bufnr }
    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
  end,
  shading_factor = -20,
})

M.lazygit_toggle = function()
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    on_open = function(term)
      vim.keymap.del("t", "<Esc><Esc>", { buffer = term.bufnr })
    end,
  })
  lazygit:toggle()
end

return M
