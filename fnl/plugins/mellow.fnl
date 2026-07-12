;; ---------------------------------------------------------------------------
;; mellow colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; mellow
  (vim.pack.add [{:src "https://github.com/mellow-theme/mellow.nvim"}])
  (local c (. (require :mellow.colors) :dark))
  (set vim.g.mellow_transparent (= (vim.fn.expand :$NEOVIM_TRANSPARENT) :1))
  (set vim.g.mellow_italic_keywords true)
  (set vim.g.mellow_bold_functions true)
  (local overrides
         {:Delimiter                      {:fg c.gray03}
          ;; FIXME: this is a test.
          :MiniHipatternsFixme            {:fg c.bg :bg c.cyan :bold true}
          ;; HACK: this is a test.
          :MiniHipatternsHack             {:fg c.bg :bg c.red :bold true}
          ;; NOTE: this is a note.
          :MiniHipatternsNote             {:fg c.bg :bg c.yellow :bold true}
          ;; TODO: this is a test.
          :MiniHipatternsTodo             {:fg c.bg :bg c.blue :bold true}
          :MiniJump                       {:sp c.yellow :undercurl true}
          :MiniStatuslineDirectory        {:fg c.gray05}
          :MiniStatuslineFilenameModified {:fg c.red :bold true}
          :NormalNC                       {:link :Normal}
          :RenderMarkdownBullet           {:fg c.cyan}
          :RenderMarkdownCodeBorder       {:bg c.black}
          :RenderMarkdownTableHead        {:fg c.gray03}
          :RenderMarkdownTableRow         {:fg c.gray03}
          :Search                         {:sp c.bright_yellow :underdouble true}})
  ;; "@..." keys are set via `tset` because fnlfmt rewrites literal "@..."
  ;; table keys into :@... keywords, which hotpot's fennel cannot parse.
  (tset overrides "@markup.heading"                  {:fg c.bright_cyan :bold true})
  (tset overrides "@markup.heading.1"                {:fg c.bright_cyan :italic false :bold true})
  (tset overrides "@markup.heading.2"                {:fg c.blue :italic false :bold true})
  (tset overrides "@markup.heading.3"                {:fg c.red :italic false :bold true})
  (tset overrides "@markup.heading.4"                {:fg c.green :italic false :bold true})
  (tset overrides "@markup.heading.5"                {:fg c.yellow :italic false :bold true})
  (tset overrides "@markup.heading.6"                {:fg c.magenta :italic false :bold true})
  (tset overrides "@markup.strong"                   {:fg c.cyan :bold true})
  (tset overrides "@markup.italic"                   {:fg c.cyan :italic true})
  (tset overrides "@lsp.typemod.type.defaultLibrary" {:fg c.bright_red})
  (set vim.g.mellow_highlight_overrides overrides)
  ;; (vim.cmd.colorscheme :mellow)
  )
