;; ---------------------------------------------------------------------------
;; conform
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; Module-local state (was Config.disable_autoformat -- only conform reads it)
(var disable-autoformat false)

;; Toggle format-on-save; bound to '\f' in keymaps
(fn toggle []
  (set disable-autoformat (not disable-autoformat))
  (vim.notify (.. "Auto-format " (if disable-autoformat :disabled :enabled))))

(with-later! ; conform
  (vim.pack.add [{:src "https://github.com/stevearc/conform.nvim"}])
  (local conform (require :conform))
  (conform.setup {:notify_on_error true
                  :format_on_save (fn [bufnr]
                                    ;; Disabled via the toggle above
                                    (when (not disable-autoformat)
                                      {:timeout_ms 2000 :lsp_format :fallback}))
                  ;; Map of filetype to formatters
                  :formatters_by_ft {:css [:prettierd]
                                     :fennel [:fnlfmt]
                                     :html [:prettierd]
                                     :javascript [:prettierd]
                                     :json [:prettierd]
                                     :yaml [:prettierd]
                                     :lua [:stylua]
                                     :sh [:shfmt]
                                     :bash [:shfmt]
                                     :markdown [:prettierd]
                                     ;; :python [:isort :black]  ; testing ruff instead now
                                     :sql [:sqruff]}}))

{: toggle}
