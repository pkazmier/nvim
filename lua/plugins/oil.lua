-- ---------------------------------------------------------------------------
-- oil
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now_if_args(function()
  vim.pack.add({ { src = "https://github.com/stevearc/oil.nvim" } })
  -- Free <C-h>/<C-l> for window navigation (mini.basics `windows`); their
  -- oil actions move to <C-x> (pairs with <C-s> vertical) and gr.
  require("oil").setup({
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["gr"] = "actions.refresh",
      ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
    },
  })
end)
