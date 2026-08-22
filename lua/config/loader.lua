-- ---------------------------------------------------------------------------
-- Deferred loading helpers
-- ---------------------------------------------------------------------------
--
-- Every plugin module wraps its setup in one of these so a failure in one
-- plugin cannot take down the rest of the config (MiniMisc.safely).

local misc = require("mini.misc")

local M = {}

function M.now(f) misc.safely("now", f) end

function M.later(f) misc.safely("later", f) end

-- Decided once at startup: with file/dir args, "now_if_args" thunks run
-- synchronously so editing-critical plugins are ready on first paint.
M.now_if_args = vim.fn.argc(-1) > 0 and M.now or M.later

function M.on_event(ev, f) misc.safely("event:" .. ev, f) end

function M.on_filetype(ft, f) misc.safely("filetype:" .. ft, f) end

function M.on_packchanged(plugin_name, kinds, callback, desc)
  local handler = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end

  local autocmds = require("config.autocmds")
  autocmds.new("PackChanged", { pattern = "*", callback = handler, desc = desc })
end

return M
