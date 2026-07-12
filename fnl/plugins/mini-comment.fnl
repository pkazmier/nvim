;; ---------------------------------------------------------------------------
;; mini.comment
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.comment
  ;; `comment` is a fennel special form, so the local needs another name
  (local mini-comment (require :mini.comment))
  (mini-comment.setup))
