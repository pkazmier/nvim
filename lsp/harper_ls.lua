-- Override neovim-lspconfig which sets it for a LOT of filetypes
vim.lsp.config("harper_ls", {
  filetypes = { "markdown", "html" },
})

-- This table is merged with the rest of the neovim-lspconfig
return {
  settings = {
    ["harper-ls"] = {
      linters = {
        SpellCheck = false,
        SentenceCapitalization = false,
      },
    },
  },
}
