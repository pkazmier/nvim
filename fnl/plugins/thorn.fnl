;; ---------------------------------------------------------------------------
;; thorn colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

;; fnlfmt: skip
(with-now! ; thorn
  (vim.pack.add [{:src "https://github.com/jpwol/thorn.nvim"}])
  (local thorn (require :thorn))
  (thorn.setup {:on_highlights (fn [hl p]
                                 (set hl.LeapLabel               {:fg p.bg :bg p.orange :bold true})
                                 (set hl.MiniStatuslineDirectory {:bg p.statusbar.bg :fg p.fg})
                                 (set hl.MiniStatuslineFilename  {:bg p.statusbar.bg :fg p.fg :bold true})
                                 (set hl.RenderMarkdownTableHead {:fg p.green_5})
                                 (set hl.RenderMarkdownTableRow  {:fg p.green_5})
                                 (tset hl "@markup.strong"       {:fg p.green_2 :bold true})
                                 (tset hl "@markup.italic"       {:fg p.green_2 :italic true}))})
  (vim.cmd.colorscheme :thorn))
