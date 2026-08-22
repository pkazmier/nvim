-- ---------------------------------------------------------------------------
-- mini.pairs
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() require("mini.pairs").setup({ modes = { command = true } }) end)
