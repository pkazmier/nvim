-- ---------------------------------------------------------------------------
-- mini.trailspace
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() require("mini.trailspace").setup() end)
