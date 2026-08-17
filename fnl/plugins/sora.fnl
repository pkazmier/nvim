;; ---------------------------------------------------------------------------
;; sora colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

;; fnlfmt: skip
(with-now! ; sora
  (vim.pack.add [{:src "https://github.com/Aejkatappaja/sora"}])
  ;; (vim.cmd.packadd :sora-dev)
  (local sora (require :sora))

  (let [transparent true]
    (sora.setup
      {:background :hard
       :transparent transparent
       :on_highlights (fn [hl c]
                        ;; Leap
                        (set hl.LeapLabel                      {:fg c.accent :bold true})
                        (set hl.LeapBackdrop                   {:fg c.fg_gutter})

                        ;; I have customized mini.statusline to allow me to
                        ;; style the filename and directory separately as well
                        ;; as whether or not the filename has been modified.
                        (set hl.MiniStatuslineDirectory        {:fg c.fg_dim :bg c.bg_elevated})
                        (set hl.MiniStatuslineFilename         {:fg c.fg_dim :bg c.bg_elevated :bold true})
                        (set hl.MiniStatuslineFilenameModified {:fg c.fg_dim :bg c.bg_elevated :bold true})

                        ;; Unreleased mini module
                        (set hl.MiniStatuscolumnSep            {:fg c.guide})
                        (set hl.MiniStatuscolumnSepCursor      {:fg c.guide})

                        (when transparent
                          (set hl.CursorLine  {:bg "NONE"})
                          (set hl.Folded      {:fg c.comment})
                          (set hl.PmenuBorder {:fg c.border})
                          (set hl.Pmenu       {:fg c.fg})
                          (set hl.PmenuKind   {:fg c.purple})
                          (set hl.PmenuExtra  {:fg c.fg_dim}))
                          )}))
(vim.cmd.colorscheme :sora))
