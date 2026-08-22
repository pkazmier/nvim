-- ---------------------------------------------------------------------------
-- mini.sessions
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now(function() require("mini.sessions").setup() end)
