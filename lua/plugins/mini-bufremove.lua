-- ---------------------------------------------------------------------------
-- mini.bufremove
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() require("mini.bufremove").setup() end)
