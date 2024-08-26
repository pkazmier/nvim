local H = {}

require("mini.notify").setup({
  content = { sort = H.filterout_lua_diagnosing },
  window = { max_width_share = 0.75, config = { border = "single" } },
})

-- FIXME: don't rely on the globals
vim.notify = MiniNotify.make_notify()

H.filterout_lua_diagnosing = function(notif_arr)
  local not_diagnosing = function(notif)
    return not vim.startswith(notif.msg, "lua_ls: Diagnosing")
  end
  notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
  return MiniNotify.default_sort(notif_arr)
end
