;; ---------------------------------------------------------------------------
;; kanagawa colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; kanagawa
  (vim.pack.add [{:src "https://github.com/rebelot/kanagawa.nvim"}])
  (local kanagawa (require :kanagawa))
  (kanagawa.setup {:colors {:palette {;; slightly less yellow
                                      :oldWhite "#C7C19F"
                                      ;; slightly dimmer
                                      :fujiWhite "#CFCAB0"}
                            :theme {:wave {:ui {:float {:bg "#1a1a22" :bg_border "#1a1a22"}}}}}
                   :overrides (fn [colors]
                                (local t colors.theme)
                                (local c colors.palette)
                                (local overrides
                                       {:BlinkCmpLabelMatch             {:fg t.syn.fun :bold true}
                                        :MiniClueDescGroup              {:fg c.crystalBlue}
                                        :MiniClueNextKey                {:fg c.oniViolet}
                                        :MiniClueNextKeyWithPostkeys    {:fg c.sakuraPink}
                                        :MiniHipatternsFixme            {:fg c.bg :bg t.diag.error}
                                        :MiniHipatternsHack             {:fg c.bg :bg t.diag.warning}
                                        :MiniHipatternsNote             {:fg c.bg :bg t.diag.info}
                                        :MiniHipatternsTodo             {:fg c.bg :bg t.diag.hint}
                                        :MiniFilesTitleFocused          {:fg t.ui.fg_dim :bold true}
                                        :MiniMapNormal                  {:fg t.ui.nontext :bg t.ui.float.bg}
                                        :MiniPickMatchRanges            {:fg t.syn.fun :bold true}
                                        :MiniStarterInactive            {:fg c.fujiGray}
                                        :MiniStarterItemBullet          {:fg c.dragonBlue :bold true}
                                        :MiniStarterItemPrefix          {:fg c.carpYellow :bold true}
                                        :MiniStarterQuery               {:fg c.crystalBlue :bold true}
                                        :MiniStarterSection             {:fg c.waveAqua1 :bold true}
                                        :MiniStarterHeader              {:fg c.springBlue}
                                        :MiniStatuslineModeNormal       {:fg t.ui.bg :bg c.springBlue}
                                        :MiniStatuslineFileinfo         {:bg t.ui.bg_visual}
                                        :MiniStatuslineDevinfo          {:bg t.ui.bg_visual}
                                        :MiniStatuslineDirectory        {:fg c.oldWhite}
                                        :MiniStatuslineFilename         {:fg c.fujiWhite :bold true}
                                        :MiniStatuslineFilenameModified {:fg c.fujiWhite :bold true}
                                        :MiniTablineCurrent             {:fg c.springBlue :bg t.ui.bg_p1 :bold true}
                                        :MiniTablineModifiedCurrent     {:fg t.ui.bg_p1 :bg c.springBlue :bold true}
                                        :RenderMarkdownBullet           {:fg t.syn.string}
                                        :RenderMarkdownCode             {:bg t.ui.float.bg}
                                        :RenderMarkdownCodeBorder       {:bg c.waveBlue1}
                                        :RenderMarkdownTableHead        {:fg c.oniViolet}
                                        :RenderMarkdownTableRow         {:fg c.oniViolet}})
                                ;; "@..." keys are set via `tset` because fnlfmt rewrites literal "@..."
                                ;; table keys into :@... keywords, which hotpot's fennel cannot parse.
                                (tset overrides "@markup.heading"   {:fg t.syn.string :bold true})
                                (tset overrides "@markup.heading.1" {:fg c.oniViolet :bold true})
                                (tset overrides "@markup.heading.2" {:fg c.waveRed :bold true})
                                (tset overrides "@markup.heading.3" {:fg c.springBlue :bold true})
                                (tset overrides "@markup.heading.4" {:fg c.springGreen :bold true})
                                (tset overrides "@markup.heading.5" {:fg c.waveAqua2 :bold true})
                                (tset overrides "@markup.heading.6" {:fg c.surimiOrange :bold true})
                                (tset overrides "@markup.strong"    {:fg t.syn.string :bold true})
                                (tset overrides "@markup.italic"    {:fg t.syn.string :italic true})
                                overrides)})
  ;; (vim.cmd.colorscheme :kanagawa)
  )
