-- ---------------------------------------------------------------------------
-- undotree
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function() vim.cmd.packadd("nvim.undotree") end)
