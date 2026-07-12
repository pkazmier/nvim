;; ---------------------------------------------------------------------------
;; mini.move
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.move
  (local move (require :mini.move))
  (move.setup))
