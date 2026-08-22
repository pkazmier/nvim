-- ---------------------------------------------------------------------------
-- mini.extra
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() require("mini.extra").setup() end)
