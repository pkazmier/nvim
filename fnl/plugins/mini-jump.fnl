;; ---------------------------------------------------------------------------
;; mini.jump
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.jump
  (local jump (require :mini.jump))
  (jump.setup))
