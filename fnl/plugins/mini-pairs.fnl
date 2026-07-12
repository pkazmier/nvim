;; ---------------------------------------------------------------------------
;; mini.pairs
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.pairs
  (local pairs (require :mini.pairs))
  (pairs.setup {:modes {:command true}}))
