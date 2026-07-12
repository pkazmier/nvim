;; ---------------------------------------------------------------------------
;; _core.ui2
;; ---------------------------------------------------------------------------
;;
;; Enable the experimental 'ui2' from neovim-0.12+
;;
;; Provides syntax highlighting in command line as well as a buffer
;; for messages that are shown. You enter the message buffer with 'g<'.
(import-macros {: with-now!} :macros)

(with-now! ; ui2
  (local ui2 (require :vim._core.ui2))
  (ui2.enable {}))
