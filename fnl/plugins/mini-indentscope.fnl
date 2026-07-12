;; ---------------------------------------------------------------------------
;; mini.indentscope
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.indentscope
  (local indentscope (require :mini.indentscope))
  (indentscope.setup {}))
