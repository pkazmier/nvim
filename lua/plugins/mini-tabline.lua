-- ---------------------------------------------------------------------------
-- mini.tabline
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")
local tabline = require("mini.tabline")

local M = {}

-- Map of buffer ids that have been "pinned".
local pinned = {}

local pinned_format = function(buf_id, label)
  local default = tabline.default_format(buf_id, label)
  return pinned[buf_id] and string.format("%s", default) or default
end

loader.now(function() tabline.setup({ format = pinned_format }) end)

function M.toggle_pinned()
  local buf_id = vim.api.nvim_get_current_buf()
  pinned[buf_id] = not pinned[buf_id]
  vim.cmd("redrawtabline")
end

function M.remove_pinned(action, force)
  local bufremove = require("mini.bufremove")
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf_id].buflisted and not pinned[buf_id] then bufremove[action](buf_id, force) end
  end
end

-- Forget a buffer's pinned state when it's removed.
autocmds.new({ "BufDelete", "BufWipeout" }, {
  callback = function(args) pinned[args.buf] = nil end,
})

return M
