-- ---------------------------------------------------------------------------
-- Initialization
-- ---------------------------------------------------------------------------

-- Bootstrap with mini
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Setup 'mini.deps' for access to `now` and `later` helpers
require("mini.deps").setup()

-- Define global config table for sharing between modules
_G.Config = {}
