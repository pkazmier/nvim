-- ---------------------------------------------------------------------------
-- friendly-snippets
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() vim.pack.add({ { src = "https://github.com/rafamadriz/friendly-snippets" } }) end)
