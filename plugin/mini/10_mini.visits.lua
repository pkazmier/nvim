-- ---------------------------------------------------------------------------
-- mini.visits
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  require("mini.visits").setup()

  Config.minivisits_pick = function(cwd, label)
    local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
    local name = "Visit " .. label .. " (" .. (cwd and "all" or "cwd") .. ")"
    local local_opts = { cwd = cwd, filter = label, sort = sort_latest }
    MiniExtra.pickers.visit_paths(local_opts, { source = { name = name } })
  end
end)
