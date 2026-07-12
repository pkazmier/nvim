;; ---------------------------------------------------------------------------
;; lume colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; lume
  (vim.pack.add [{:src "https://github.com/danfry1/lume"}])
  ;; (vim.cmd.packadd :lume-dev)
  (local lume (require :lume))
  (lume.setup {:palette_overrides {:backgrounds {:crust    "#141029"
                                                 :mantle   "#19162B"
                                                 :base     "#1F1B33"
                                                 :surface0 "#2B2640"
                                                 :surface1 "#342F4A"
                                                 :surface2 "#3F3A57"}
                                   :special {:selection "#484066"}}
               :custom_highlights (fn [colors variant]
                                    (local fg colors.foregrounds)
                                    (local bg colors.backgrounds)
                                    (local ac colors.accents)
                                    (local overrides
                                           {;; Dim the line numbers as they are too bright for my taste
                                            :LineNr                         {:fg bg.surface2}
                                            :TreesitterContextLineNumber    {:fg bg.surface2}
                                            :PmenuBorder                    {:fg bg.surface2 :bg bg.surface0}
                                            ;; Make the sign column bg transparent because the default in lume
                                            ;; assigns the Normal background, which looks weird on non-current
                                            ;; windows because there is no such thing SignColumnNC. So we fix
                                            ;; that by setting the bg to NONE which inherits the bg instead.
                                            :SignColumn                     {:bg :NONE}
                                            :LeapBackdrop                   {:link :MiniJump2dDim}
                                            :LeapLabel                      {:fg ac.honey :bold true}
                                            :MiniClueDescGroup              {:fg ac.sky}
                                            :MiniClueSeparator              {:fg bg.surface2}
                                            :MiniJump                       {:sp ac.honey :fg :NONE :bg :NONE :undercurl true}
                                            :MiniStarterItemPrefix          {:fg ac.teal :bold true}
                                            :MiniStarterInactive            {:fg fg.comment}
                                            :MiniStarterQuery               {:fg ac.peach :bold true}
                                            :MiniStarterSection             {:fg ac.sky :bold true}
                                            :MiniStarterFooter              {:fg fg.comment :italic true}
                                            ;; surface1 looks better than mantle for those with `laststatus=2`
                                            :MiniStatuslineInactive         {:fg fg.overlay :bg bg.surface1}
                                            :MiniStatuslineDirectory        {:fg fg.overlay :bg bg.mantle}
                                            :MiniStatuslineFilename         {:fg fg.subtext :bg bg.mantle :bold true}
                                            :MiniStatuslineFilenameModified {:fg fg.subtext :bg bg.mantle :bold true}
                                            :MiniStatuslineDevinfo          {:fg fg.subtext :bg bg.surface2}
                                            :MiniStatuslineFileinfo         {:fg fg.subtext :bg bg.surface2}
                                            :MiniTablineCurrent             {:fg ac.sage :bg bg.base :bold true}
                                            :MiniTablineHidden              {:fg fg.comment :bg bg.crust}
                                            :MiniTablineVisible             {:fg fg.text :bg bg.mantle}
                                            :MiniTablineFill                {:bg bg.crust}
                                            :MiniTablineModifiedCurrent     {:fg bg.crust :bg ac.sage :bold true}
                                            :MiniTablineModifiedVisible     {:fg bg.crust :bg fg.text}
                                            :MiniTablineModifiedHidden      {:fg bg.crust :bg fg.comment}
                                            :RenderMarkdownDash             {:fg ac.rose}
                                            :RenderMarkdownBullet           {:fg ac.rose}
                                            :RenderMarkdownCode             {:bg bg.surface0}
                                            :RenderMarkdownCodeBorder       {:bg bg.surface1}
                                            :RenderMarkdownCodeInline       {:fg ac.sage :bg bg.surface0}
                                            :RenderMarkdownChecked          {:fg ac.sage}
                                            :RenderMarkdownUnchecked        {:fg fg.overlay}
                                            :RenderMarkdownTodo             {:fg ac.sky}
                                            :RenderMarkdownLink             {:fg ac.teal}
                                            :RenderMarkdownTableHead        {:fg bg.surface2}
                                            :RenderMarkdownTableRow         {:fg bg.surface2}})
                                    ;; "@..." keys are set via `tset` because fnlfmt rewrites literal "@..."
                                    ;; table keys into :@... keywords, which hotpot's fennel cannot parse.
                                    (tset overrides "@property"          {:fg ac.teal})
                                    (tset overrides "@lsp.type.variable" {:link "@lsp"})
                                    (tset overrides "@lsp.type.property" {:link "@property"})
                                    overrides)}))
