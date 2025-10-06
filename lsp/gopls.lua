-- This table is merged with the rest of the neovim-lspconfig
return {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      semanticTokens = true,
      semanticTokenTypes = { keyword = false },
    },
  },
}
