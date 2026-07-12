;; ---------------------------------------------------------------------------
;; mini.input
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.input
  (local input (require :mini.input))
  (input.setup))
