-- ---------------------------------------------------------------------------
-- mini.splitjoin
-- ---------------------------------------------------------------------------
--
-- Fennel-specific behavior (whitespace separators, glued brackets) lives in
-- after/ftplugin/fennel.lua as buffer-local config.

local loader = require("config.loader")

loader.later(function() require("mini.splitjoin").setup() end)
