-- ---------------------------------------------------------------------------
-- mini.map
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")
local map = require("mini.map")

local H = {}
local M = {}

loader.now_if_args(function()
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
    symbols = {
      encode = map.gen_encode_symbols.dot("4x2"),
    },
    window = {
      -- place above treesitter-context, which is 20
      zindex = 21,
    },
  })

  -- Refresh minimap on certain movements
  for _, key in ipairs({ "n", "N", "*", "#" }) do
    vim.keymap.set("n", key, key .. "zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>")
  end
end)

-- Filetypes where the minimap is enabled automatically.
-- stylua: ignore
local auto_enable = {
  go       = true,
  lua      = true,
  fennel   = true,
  markdown = true,
  python   = true,
  rust     = true,
}

-- Return true if the current buffer is supposed to have a map.
-- vim.b.minimap_disable is a tri-state: false = explicitly enabled via
-- buf_toggle, true = explicitly disabled, nil = defer to the filetype
-- auto_enable table.
H.should_be_enabled = function()
  local disable = vim.b.minimap_disable
  if disable == false then return true end
  if disable == true then return false end
  return auto_enable[vim.bo.filetype]
end

-- Toggle the global visibility of the map. If it is currently shown, then
-- hide it. If it is not, then show it if the current buffer is supposed to
-- have a map.
function M.toggle()
  vim.g.minimap_disable = not vim.g.minimap_disable
  if H.should_be_enabled() then map.toggle() end
end

-- Toggle whether the current buffer should display a map if it has not been
-- globally disabled via toggle.
function M.buf_toggle()
  if H.should_be_enabled() then
    vim.b.minimap_disable = true
    map.close()
  else
    vim.b.minimap_disable = false
    map.open()
  end
end

autocmds.new("BufEnter", {
  desc = "Toggle 'mini.map' based on filetype",
  callback = vim.schedule_wrap(function()
    -- Do nothing if entering the minimap buffer itself (when focusing)
    if vim.bo.filetype == "minimap" then return end

    -- Otherwise check if the minimap should be opened or not
    if H.should_be_enabled() then
      map.open()
    else
      map.close()
    end
  end),
})

return M
