-- ---------------------------------------------------------------------------
-- mini.input
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() require("mini.input").setup() end)
