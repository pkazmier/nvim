;; ---------------------------------------------------------------------------
;; lazydev
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; lazydev
  (vim.pack.add [{:src "https://github.com/folke/lazydev.nvim"}])
  (local lazydev (require :lazydev))
  (lazydev.setup))
