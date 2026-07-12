;; ---------------------------------------------------------------------------
;; mini.extra
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.extra
  (local extra (require :mini.extra))
  (extra.setup))
