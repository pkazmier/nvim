local map = require("mini.map")

-- stylua: ignore start
local enable = {
  go       = true,
  lua      = true,
  markdown = true,
  python   = true,
  rust     = true,
}
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
-- stylua: ignore end

for _, key in ipairs({ "n", "N", "*" }) do
  vim.keymap.set("n", key, key .. "zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>")
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("kaz-minimap", { clear = true }),
  desc = "Toggle 'mini.map' based on filetype",
  callback = function(data)
    if vim.bo[data.buf].buftype ~= "" then
      return
    end
    local ft = vim.bo[data.buf].filetype
    if enable[ft] then
      MiniMap.open()
    else
      MiniMap.close()
    end
  end,
})
