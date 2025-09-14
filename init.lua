-- Bootstrap with mini
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Set up 'mini.deps' immediately to have its `now()` and `later()` helpers
require("mini.deps").setup()

-- Define main config table to be able to use it in scripts
_G.Config = {}
