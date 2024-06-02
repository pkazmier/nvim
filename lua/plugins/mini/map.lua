local M = {}
local H = {}
local map = require("mini.map")

-- stylua: ignore
M.auto_enable = {
  go       = true,
  lua      = true,
  markdown = true,
  python   = true,
  rust     = true,
}

-- stylua: ignore
map.setup({
  integrations = {
    map.gen_integration.builtin_search(),
    map.gen_integration.diff(),
    map.gen_integration.diagnostic({
      error = "DiagnosticFloatingError",
      warn  = "DiagnosticFloatingWarn",
      info  = "DiagnosticFloatingInfo",
      hint  = "DiagnosticFloatingHint",
    }),
  },
  symbols = {
    encode = map.gen_encode_symbols.dot("4x2"),
  },
  window = {
    -- place above treesitter-context, which is 20
    zindex = 21,
  },
})

for _, key in ipairs({ "n", "N", "*" }) do
  vim.keymap.set("n", key, key .. "zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>")
end

-- Return true if the current buffer is supposed to have a map.
-- 1. User has expilicity enabled it via M.buf_toggle
-- 2. Filetype of buffer is in the M.auto_enable table
H.should_be_enabled = function()
  local ft = vim.bo.filetype
  local disabled = vim.b.minimap_disable
  local enabled_explicitly = vim.b.minimap_disable == false
  return enabled_explicitly or M.auto_enable[ft] and not disabled
end

-- Toggle the global visibility of the map. If it is currently shown, then
-- hide it. If it is not, then show it if the current buffer is supposed to
-- have a map.
M.toggle = function()
  vim.g.minimap_disable = not vim.g.minimap_disable
  if H.should_be_enabled() then
    MiniMap.toggle()
  end
end

-- Toggle whether the current buffer should display a map if it has not been
-- globally disabled via M.toggle.
M.buf_toggle = function()
  if H.should_be_enabled() then
    vim.b.minimap_disable = true
    MiniMap.close()
  else
    vim.b.minimap_disable = false
    MiniMap.open()
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("kaz-minimap", { clear = true }),
  desc = "Toggle 'mini.map' based on filetype",
  callback = function()
    if H.should_be_enabled() then
      MiniMap.open()
    else
      MiniMap.close()
    end
  end,
})

return M
