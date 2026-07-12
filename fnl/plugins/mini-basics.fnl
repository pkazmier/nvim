;; ---------------------------------------------------------------------------
;; mini.basics
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(with-now! ; mini.basics
  (local basics (require :mini.basics))
  (basics.setup {:mappings {:windows true :move_with_alt true}
                 :autocommands {:relnum_in_visual_mode true}}))
