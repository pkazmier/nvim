-- ---------------------------------------------------------------------------
-- Initialization
-- ---------------------------------------------------------------------------

-- Bootstrap with mini
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Define global config table for sharing between modules
_G.Config = {}

-- Setup 'mini.misc' for access to `MiniMisc.safely()`
local misc = require("mini.misc")

-- Define package helpers
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely("filetype:" .. ft, f) end
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end
