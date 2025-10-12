local H = {}
MiniDeps.later(function()
  local map = require("mini.map")

  -- stylua: ignore
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

  -- Toggle the global visibility of the map. If it is currently shown, then
  -- hide it. If it is not, then show it if the current buffer is supposed to
  -- have a map.
  Config.minimap_toggle = function()
    vim.g.minimap_disable = not vim.g.minimap_disable
    if H.minimap_should_be_enabled() then
      MiniMap.toggle()
    end
  end

  -- Toggle whether the current buffer should display a map if it has not been
  -- globally disabled via M.toggle.
  Config.minimap_buf_toggle = function()
    if H.minimap_should_be_enabled() then
      vim.b.minimap_disable = true
      MiniMap.close()
    else
      vim.b.minimap_disable = false
      MiniMap.open()
    end
  end

  -- stylua: ignore
  local auto_enable = {
    go       = true,
    lua      = true,
    markdown = true,
    python   = true,
    rust     = true,
  }

  -- Return true if the current buffer is supposed to have a map.
  -- 1. User has expilicity enabled it via M.buf_toggle
  -- 2. Filetype of buffer is in the auto_enable table
  H.minimap_should_be_enabled = function()
    local ft = vim.bo.filetype
    local disabled = vim.b.minimap_disable
    local enabled_explicitly = vim.b.minimap_disable == false
    return enabled_explicitly or auto_enable[ft] and not disabled
  end

  Config.new_autocmd("BufEnter", {
    desc = "Toggle 'mini.map' based on filetype",
    callback = vim.schedule_wrap(function()
      if H.minimap_should_be_enabled() then
        MiniMap.open()
      else
        MiniMap.close()
      end
    end),
  })
end)
