-- ---------------------------------------------------------------------------
-- lsp
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { load = true })

  -- All language servers are expected to be installed with 'mason.vnim'
  vim.lsp.enable({
    "gopls",
    "lua_ls",
    "basedpyright",
    "marksman",
    "ruff",
    "harper_ls",
    "helm_ls",
    "rust_analyzer",
    "ts_ls",
    "jsonls",
    "yamlls",
    "zls",
  })

  Config.toggle_hints = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
end)
