-- ---------------------------------------------------------------------------
-- Fennel compiler (hotpot)
-- ---------------------------------------------------------------------------

-- Install and enable hotpot FIRST, so its module loader is active for every
-- subsequent `require` and for auto-sourced runtime files (ftplugin/,
-- after/ftplugin/, lsp/, colors/, ...). Everything else in this config is
-- Fennel: any `*.fnl` is compiled ahead of time (on save) and loaded
-- transparently.
vim.pack.add({ { src = "https://github.com/rktjmp/hotpot.nvim" } })

require("hotpot")

-- ---------------------------------------------------------------------------
-- Load configuration
-- ---------------------------------------------------------------------------

-- mini.nvim is needed before the config loads: config/loader.fnl (required by
-- every with-* macro expansion) builds on MiniMisc.safely().
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- The explicit, ordered load list lives in fnl/config/init.fnl.
require("config")
