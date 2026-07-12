;; ---------------------------------------------------------------------------
;; mini.misc
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(with-now-if-args! ; mini.misc
  (local misc (require :mini.misc))
  (misc.setup {:make_global [:put :put_text :stat_summary :bench_time]})
  (misc.setup_auto_root)
  (misc.setup_restore_cursor)
  (misc.setup_termbg_sync))
