;; ---------------------------------------------------------------------------
;; mini.notify
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(with-now! ; mini.notify
  (local notify (require :mini.notify))
  (notify.setup {:window {:max_width_share 0.75 :winblend 0}}))
