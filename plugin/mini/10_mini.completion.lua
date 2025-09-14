MiniDeps.later(function()
  require("mini.completion").setup({
    lsp_completion = { source_func = "omnifunc", auto_setup = false },
  })
  local on_attach = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end
  vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)
