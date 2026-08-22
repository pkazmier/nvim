-- ---------------------------------------------------------------------------
-- vim-helm
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now_if_args(function() vim.pack.add({ { src = "https://github.com/towolf/vim-helm" } }) end)
