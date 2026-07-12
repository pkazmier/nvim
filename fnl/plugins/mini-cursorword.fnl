;; ---------------------------------------------------------------------------
;; mini.cursorword
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; Toggle function, which is bound to '\W' in keymaps
(fn toggle []
  (set vim.g.minicursorword_disable (not vim.g.minicursorword_disable))
  (vim.cmd "doautocmd CursorMoved"))

(with-later! ; mini.cursorword
  (local cursorword (require :mini.cursorword))
  (cursorword.setup))

{: toggle}
