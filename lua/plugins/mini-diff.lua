-- ---------------------------------------------------------------------------
-- mini.diff
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local functions = require("config.functions")

-- `clues` can't be set here: it is produced by the later thunk
-- (gen_hydra_brackets reads mappings that exist only after setup), so the
-- thunk fills it in after the module has already returned this table.
-- mini.clue (queued after us in the manifest) asserts on it.
local M = {}

function M.to_qf()
  vim.fn.setqflist(require("mini.diff").export("qf"))
  vim.cmd("copen")
end

loader.later(function()
  require("mini.diff").setup()

  -- better mini.diff 'h/H' mapping
  M.clues = functions.gen_hydra_brackets({ "h" }, {
    ["["] = { old = "first", new = "next" },
    ["]"] = { old = "last", new = "prev" },
  })
end)

return M
