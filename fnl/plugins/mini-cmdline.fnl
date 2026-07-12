;; ---------------------------------------------------------------------------
;; mini.cmdline
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.cmdline
  (local cmdline (require :mini.cmdline))
  (cmdline.setup {:autocomplete {:delay 200} :autopeek {:n_context 1}}))
