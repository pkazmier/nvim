-- ---------------------------------------------------------------------------
-- mini.misc
-- ---------------------------------------------------------------------------

local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
now_if_args(function()
  require("mini.misc").setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)
