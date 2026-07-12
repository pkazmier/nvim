;; ---------------------------------------------------------------------------
;; mini.sessions
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(with-now! ; mini.sessions
  (local sessions (require :mini.sessions))
  (sessions.setup))
