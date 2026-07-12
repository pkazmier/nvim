;; ---------------------------------------------------------------------------
;; undotree
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; undotree
  (vim.cmd.packadd :nvim.undotree))
