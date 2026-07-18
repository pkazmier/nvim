;; ---------------------------------------------------------------------------
;; mini.notify
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(with-now! ; mini.notify
  (local notify (require :mini.notify))
  (notify.setup {:lsp_progress {:enable false}
                 :window {:max_width_share 0.75 :winblend 0}}))
