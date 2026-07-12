;; ---------------------------------------------------------------------------
;; boo-berry colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; boo-berry
  (vim.pack.add [{:src "https://github.com/booberrytheme/boo-berry.nvim"}])
  (local boo-berry (require :boo-berry))
  (boo-berry.setup {:overrides (fn [c]
                                 (local overrides
                                        {:DiagnosticError                {:fg c.pink}
                                         :DiagnosticWarn                 {:fg c.yellow}
                                         :DiagnosticOk                   {:fg c.green}
                                         :DiagnosticInfo                 {:fg c.purple}
                                         :DiagnosticHint                 {:fg c.purple}
                                         :MiniStatuslineDirectory        {:fg c.comment :bg c.menu}
                                         :MiniStatuslineFilename         {:bg c.menu :bold true}
                                         :MiniStatuslineFilenameModified {:bg c.menu :bold true}
                                         :MiniTablineModifiedCurrent     {:bg c.red :fg c.bg :bold true}
                                         :MiniTablineModifiedVisible     {:fg c.bg :bg c.fg :bold true}
                                         :MiniTablineModifiedHidden      {:fg c.bg :bg c.fg}
                                         :MiniTablineVisible             {:bg c.nontext :bold true}
                                         :MiniTablineCurrent             {:fg c.red :bg c.bg :bold true}
                                         :MiniStarterQuery               {:fg c.green :bold true}
                                         :MiniStarterItemPrefix          {:fg c.yellow :bold true}
                                         :MiniStarterSection             {:fg c.red :bold true}
                                         :MiniStarterFooter              {:fg c.comment}
                                         :RenderMarkdownCode             {:bg c.nontext}
                                         :RenderMarkdownCodeBorder       {:bg c.nontext}
                                         :RenderMarkdownCodeInline       {:fg c.yellow :bg c.nontext}
                                         :RenderMarkdownTableHead        {:fg c.nontext}
                                         :RenderMarkdownTableRow         {:fg c.nontext}
                                         :RenderMarkdownChecked          {:fg c.green}
                                         :RenderMarkdownUnchecked        {:fg c.yellow}
                                         :RenderMarkdownTodo             {:fg c.yellow}
                                         :RenderMarkdownBullet           {:fg c.yellow}
                                         :RenderMarkdownLink             {:fg c.purple}})
                                 ;; "@..." keys are set via `tset` because fnlfmt rewrites literal "@..."
                                 ;; table keys into :@... keywords, which hotpot's fennel cannot parse.
                                 (tset overrides "@markup.strong"        {:fg c.red :bold true})
                                 (tset overrides "@markup.italic"        {:fg c.red :italic true})
                                 (tset overrides "@markup.heading.1"     {:fg c.purple :bold true})
                                 (tset overrides "@markup.heading.2"     {:fg c.red :bold true})
                                 (tset overrides "@markup.heading.3"     {:fg c.yellow :bold true})
                                 (tset overrides "@markup.heading.4"     {:fg c.green :bold true})
                                 (tset overrides "@markup.heading.5"     {:fg c.comment :bold true})
                                 (tset overrides "@markup.heading.6"     {:fg c.comment :bold true})
                                 overrides)}))
