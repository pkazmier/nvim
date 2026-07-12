;; ---------------------------------------------------------------------------
;; tokyonight colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; tokyonight
  (vim.pack.add [{:src "https://github.com/folke/tokyonight.nvim"}])
  (local tokyonight (require :tokyonight))
  (tokyonight.setup {:lualine_bold true
                     :on_highlights (fn [hl c]
                                      (set hl.LeapLabel                      {:fg c.blue1 :bold true})
                                      (set hl.TreesitterContext              {:bg c.bg_dark1})
                                      (set hl.TreesitterContextLineNumber    {:fg c.fg_gutter :bg c.bg_dark1})
                                      (set hl.TreesitterContextBottom        {:underline true :sp c.bg_highlight})
                                      ;; Highlight patterns for deemphasizing the directory name, so the
                                      ;; filename is more prominent. Visually, this makes it faster to
                                      ;; identify the name of the file.
                                      ;; See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
                                      (set hl.MiniStatuslineInactive         {:fg c.fg_dark :bg c.bg_dark})
                                      (set hl.MiniStatuslineDirectory        {:fg c.fg_dark :bg c.bg_highlight})
                                      (set hl.MiniStatuslineFilename         {:fg c.fg :bg c.bg_highlight :bold true})
                                      (set hl.MiniStatuslineFilenameModified {:fg c.yellow :bg c.bg_highlight :bold true})
                                      (set hl.RenderMarkdownCodeBorder       {:bg c.bg_highlight}))})
  ;; (vim.cmd.colorscheme :tokyonight-moon)
  )
