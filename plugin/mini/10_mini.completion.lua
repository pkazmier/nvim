-- ---------------------------------------------------------------------------
-- mini.completion
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  require("mini.completion").setup({
    lsp_completion = { source_func = "omnifunc", auto_setup = false },
    mappings = { force_fallback = "" },
  })
  local on_attach = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end
  Config.new_autocmd("LspAttach", { callback = on_attach })

  -- Advertise to servers that Neovim now supports certain set of completion and
  -- signature features through 'mini.completion'.
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)
