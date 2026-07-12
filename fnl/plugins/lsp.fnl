;; ---------------------------------------------------------------------------
;; lsp
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; Bound to '\H' in keymaps
(fn toggle-hints []
  (vim.lsp.inlay_hint.enable (not (vim.lsp.inlay_hint.is_enabled))))

(with-later! ; lsp
  (vim.pack.add [{:src "https://github.com/neovim/nvim-lspconfig"}])
  ;; All language servers are expected to be installed with 'mason.nvim'
  (vim.lsp.enable [:fennel_ls
                   :gopls
                   :lua_ls
                   :basedpyright
                   :marksman
                   :ruff
                   :harper_ls
                   :helm_ls
                   :rust_analyzer
                   :ts_ls
                   :jsonls
                   :yamlls
                   :zls]))

{:toggle_hints toggle-hints}
