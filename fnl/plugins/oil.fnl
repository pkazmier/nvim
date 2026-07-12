;; ---------------------------------------------------------------------------
;; oil
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(with-now-if-args! ; oil
  (vim.pack.add [{:src "https://github.com/stevearc/oil.nvim"}])
  (local oil (require :oil))
  ;; Free <C-h>/<C-l> for window navigation (mini.basics `windows`); their
  ;; oil actions move to <C-x> (pairs with <C-s> vertical) and gr.
  (oil.setup {:keymaps {:<C-h> false
                        :<C-l> false
                        :gr :actions.refresh
                        :<C-x> {1 :actions.select :opts {:horizontal true}}}}))
