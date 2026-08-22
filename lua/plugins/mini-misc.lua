-- ---------------------------------------------------------------------------
-- mini.misc
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now_if_args(function()
  local misc = require("mini.misc")
  misc.setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
  misc.setup_auto_root()
  misc.setup_restore_cursor()
  misc.setup_termbg_sync()
end)
