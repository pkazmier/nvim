-- ---------------------------------------------------------------------------
-- mini.tabline
-- ---------------------------------------------------------------------------

-- Map of buffer ids that have been "pinned".
local pinned = {}

local pinned_format = function(buf_id, label)
  local default = MiniTabline.default_format(buf_id, label)
  return pinned[buf_id] and string.format("%s", default) or default
end

Config.now(function() require("mini.tabline").setup({ format = pinned_format }) end)

Config.toggle_pinned = function()
  local buf_id = vim.api.nvim_get_current_buf()
  pinned[buf_id] = not pinned[buf_id]
  vim.cmd("redrawtabline")
end

Config.remove_pinned = function(action, force)
  local bufs = vim.api.nvim_list_bufs()
  for _, buf_id in ipairs(bufs) do
    local remove = vim.bo[buf_id].buflisted and not pinned[buf_id]
    if remove then MiniBufremove[action](buf_id, force) end
  end
end

Config.new_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args) pinned[args.buf] = nil end,
})
