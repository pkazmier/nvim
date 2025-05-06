-- This will override any on_attach function if neovim-lspconfig
-- had one defined for lua_ls, which it does not specifically.
vim.lsp.config.lua_ls = {
  on_attach = function(client, buf_id)
    -- Reduce unnecessarily long list of completion triggers for better
    -- 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }

    -- -- Override global "Go to source" mapping with dedicated buffer-local
    local opts = { buffer = buf_id, desc = "Lua source definition" }
    vim.keymap.set("n", "<Leader>cd", Config.luals_unique_definition, opts)
  end,
}

-- THis will be merged with the rest neovim-lspconfig configuration.
return {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
    telemetry = { enable = false },
  },
}
