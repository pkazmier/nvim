;; ---------------------------------------------------------------------------
;; mini.colors
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.colors
  (local colors (require :mini.colors))
  (colors.setup))
