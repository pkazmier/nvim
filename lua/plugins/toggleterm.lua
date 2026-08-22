-- ---------------------------------------------------------------------------
-- toggleterm
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

local M = {}

-- Bound to <leader>gg in keymaps
function M.lazygit()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "lazygit",
    hidden = true,
    highlights = { FloatBorder = { link = "FloatBorder" } },
    direction = "float",
    on_open = function(term) vim.keymap.del("t", "<Esc><Esc>", { buffer = term.bufnr }) end,
  })
  term:toggle()
end

loader.later(function()
  vim.pack.add({ { src = "https://github.com/akinsho/toggleterm.nvim" } })

  require("toggleterm").setup({
    direction = "float",
    highlights = {
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "FloatBorder" },
    },
    float_opts = {
      border = "rounded",
      winblend = 0,
    },
    open_mapping = [[<c-\>]],
    on_create = function(term) vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = term.bufnr }) end,
  })
end)

return M
