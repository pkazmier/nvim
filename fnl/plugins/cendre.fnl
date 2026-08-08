;; ---------------------------------------------------------------------------
;; cendre colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

;; fnlfmt: skip
(with-now! ; cendre
  (vim.pack.add [{:src "https://github.com/Aejkatappaja/cendre"}])
  ;; (vim.cmd.packadd :cendre-dev)
  (local cendre (require :cendre))

  (let [transparent false]
    (cendre.setup
      {:background :hard
       :transparent transparent
       :on_highlights (fn [hl c]
                        ;; I have customized mini.statusline to allow me to
                        ;; style the filename and directory separately as well
                        ;; as whether or not the filename has been modified.
                        (set hl.MiniStatuslineDirectory        {:fg c.fg_dim :bg c.bg2})
                        (set hl.MiniStatuslineFilename         {:fg c.fg_dim :bg c.bg2 :bold true})
                        (set hl.MiniStatuslineFilenameModified {:fg c.fg_dim :bg c.bg2 :bold true})
                        (set hl.MiniStatuscolumnSep            {:fg c.bg3})
                        (set hl.MiniStatuscolumnSepCursor      {:fg c.cinder})

                        (when transparent
                          (set hl.PmenuBorder {:fg c.bg5})
                          (set hl.Pmenu       {:fg c.fg})
                          (set hl.PmenuKind   {:fg c.frost})
                          (set hl.PmenuExtra  {:fg c.fg_dim})))}))

  (vim.cmd.colorscheme :cendre))
