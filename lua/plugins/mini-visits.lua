-- ---------------------------------------------------------------------------
-- mini.visits
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

local M = {}

function M.pick(cwd, label)
  local visits = require("mini.visits")
  local extra = require("mini.extra")
  local sort_latest = visits.gen_sort.default({ recency_weight = 1 })
  local name = "Visit " .. label .. " (" .. (cwd and "all" or "cwd") .. ")"
  local local_opts = { cwd = cwd, filter = label, sort = sort_latest }
  extra.pickers.visit_paths(local_opts, { source = { name = name } })
end

loader.later(function() require("mini.visits").setup() end)

return M
