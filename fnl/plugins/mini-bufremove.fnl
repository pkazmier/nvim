;; ---------------------------------------------------------------------------
;; mini.bufremove
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.bufremove
  (local bufremove (require :mini.bufremove))
  (bufremove.setup))
