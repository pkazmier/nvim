;; ---------------------------------------------------------------------------
;; mini.splitjoin
;; ---------------------------------------------------------------------------
;;
;; Fennel-specific behavior (whitespace separators, glued brackets) lives in
;; after/ftplugin/fennel.fnl as buffer-local config.
(import-macros {: with-later!} :macros)

(with-later! ; mini.splitjoin
  (local splitjoin (require :mini.splitjoin))
  (splitjoin.setup))
