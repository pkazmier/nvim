-- ---------------------------------------------------------------------------
-- mini.bracketed
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local functions = require("config.functions")

-- `clues` can't be set here: it is produced by the later thunk
-- (gen_hydra_brackets reads mappings that exist only after setup), so the
-- thunk fills it in after the module has already returned this table.
-- mini.clue (queued after us in the manifest) asserts on it.
local M = {}

loader.later(function()
  local bracketed = require("mini.bracketed")
  bracketed.setup()

  local suffixes = vim.tbl_map(function(v) return v.suffix end, vim.tbl_values(bracketed.config))

  -- Better mini.bracketed mappings, see comment in `gen_hydra_brackets`
  -- definition within `config/functions.lua`.
  M.clues = functions.gen_hydra_brackets(suffixes, {
    ["["] = { old = "first", new = "forward" },
    ["]"] = { old = "last", new = "backward" },
  })
end)

return M
