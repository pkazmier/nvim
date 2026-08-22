-- ---------------------------------------------------------------------------
-- mini.move
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() require("mini.move").setup() end)
