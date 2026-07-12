;; ---------------------------------------------------------------------------
;; mini.completion
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(with-now-if-args! ; mini.completion
  (local completion (require :mini.completion))
  (completion.setup {:lsp_completion {:source_func :omnifunc :auto_setup false}
                     :mappings {:force_fallback ""}})

  (fn on-attach [args]
    (tset vim.bo args.buf :omnifunc "v:lua.MiniCompletion.completefunc_lsp"))

  (local autocmds (require :config.autocmds))
  (autocmds.new :LspAttach {:callback on-attach})
  ;; Advertise to servers that Neovim now supports certain set of completion
  ;; and signature features through 'mini.completion'.
  (vim.lsp.config "*" {:capabilities (completion.get_lsp_capabilities)}))
