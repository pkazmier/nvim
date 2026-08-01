;; ---------------------------------------------------------------------------
;; rose pine colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; rose-pine
  (vim.pack.add [{:src "https://github.com/rose-pine/neovim" :name :rose-pine}])
  (local rose-pine (require :rose-pine))
  (local highlight-groups
         {:Added                       {:fg :pine}
          :Comment                     {:fg :muted :italic true}
          :FloatTitle                  {:fg :foam}
          :LineNr                      {:fg :highlight_med}
          :MiniClueDescGroup           {:fg :iris}
          :MiniClueNextKey             {:fg :love :bold true}
          :MiniClueSeparator           {:fg :highlight_med}
          :MiniClueTitle               {:fg :foam}
          ;; Bold current line only
          :MiniFilesCursorLine         {:fg :text :bg :overlay :bold true}
          :MiniFilesDirectory          {:fg :foam :bold false}
          :MiniFilesFile               {:fg :subtle}
          :MiniFilesTitle              {:fg :subtle}
          :MiniFilesTitleFocused       {:fg :foam}
          :MiniIndentscopeSymbol       {:fg :pine}
          ;; Tone down the brightness of the foreground
          :MiniMapNormal               {:fg :subtle}
          :MiniPickBorderText          {:fg :foam :bold true}
          :MiniPickMatchCurrent        {:fg :text :bg :overlay :bold true}
          :MiniPickMatchMarked         {:fg :text :bg :love :blend 30}
          :MiniPickMatchRanges         {:fg :rose :bold false}
          :MiniPickNormal              {:fg :subtle}
          :MiniPickPromptPrefix        {:fg :foam :bold true}
          :MiniStarterFooter           {:fg :muted :italic true}
          :MiniStarterHeader           {:fg :love :bold true}
          :MiniStarterInactive         {:fg :muted :italic false}
          :MiniStarterItem             {:fg :subtle}
          :MiniStarterItemPrefix       {:fg :foam :bold true}
          :MiniStarterQuery            {:fg :gold}
          :MiniStarterSection          {:fg :iris :bold true}
          :MiniStatuslineDevinfo       {:fg :iris :bg :iris :blend 30}
          :MiniStatuslineDirectory     {:fg :iris :bg :iris :blend 10}
          :MiniStatuslineFilename      {:fg :iris :bg :iris :blend 10 :bold true}
          :MiniStatuslineFilenameModified {:fg :iris :bg :iris :blend 10 :bold true}
          :MiniStatuslineInactive      {:fg :subtle :bg :surface :blend 100 :bold false}
          :MiniStatuslineModeCommand   {:fg :base :bg :pine :bold true}
          :MiniStatuslineModeInsert    {:fg :base :bg :foam :bold true}
          :MiniStatuslineModeNormal    {:fg :base :bg :love :bold true}
          :MiniStatuslineModeOther     {:fg :base :bg :gold :bold true}
          :MiniStatuslineModeReplace   {:fg :base :bg :rose :bold true}
          :MiniStatuslineModeVisual    {:fg :base :bg :iris :bold true}
          :PmenuBorder                 {:fg :muted}
          :PmenuMatch                  {:fg :rose :bold false}
          :PmenuSel                    {:bg :overlay :bold true}
          :RenderMarkdownBullet        {:fg :pine}
          :RenderMarkdownChecked       {:fg :iris}
          :RenderMarkdownCodeBorder    {:fg :iris :bg :iris :blend 20}
          :RenderMarkdownCodeInline    {:fg :iris :bg :overlay}
          :RenderMarkdownLink          {:fg :pine}
          :RenderMarkdownTableHead     {:fg :highlight_med}
          :RenderMarkdownTableRow      {:fg :highlight_med}
          :RenderMarkdownTodo          {:fg :pine}
          :RenderMarkdownUnchecked     {:fg :pine}
          :Search                      {:fg :gold :bg :gold :blend 30}
          :StatusLine                  {:fg :love :bg :love :blend 10}
          :TreesitterContextLineNumber {:fg :muted}
          :WinSeparator                {:fg :overlay}})
  ;; "@..." keys are set via `tset` because fnlfmt rewrites literal "@..."
  ;; table keys into :@... keywords, which hotpot's fennel cannot parse.
  (tset highlight-groups "@function.method.call"      {:fg :rose})
  (tset highlight-groups "@lsp.type.formatSpecifier"  {:link "@markup.list"})
  (tset highlight-groups "@lsp.type.namespace"        {:fg :text :italic true})
  (tset highlight-groups "@lsp.type.namespace.python" {:fg :text :italic true})
  (tset highlight-groups "@lsp.type.parameter"        {:link "@variable.parameter"})
  (tset highlight-groups "@variable.member.go"        {:fg :iris})
  (tset highlight-groups "@markup.heading"            {:fg :iris :bold true})
  (tset highlight-groups "@markup.italic"             {:fg :subtle :italic true})
  (tset highlight-groups "@markup.strong"             {:fg :subtle :bold true})

  (let [colors [:rose :love :foam :pine :iris :gold]
        heading-groups (collect [idx color (ipairs colors)] (.. :h idx) color)]
    (rose-pine.setup {:enable {:legacy_highlights false}
                      :groups heading-groups
                      :highlight_groups highlight-groups
                      :palette {:main
                                {;; I think rose-pine's default pine color is simply too
                                 ;; dark, so I use rose-pine's moon variant of pine.
                                 :pine "#3e8fb0"}}
                      :styles {:italic false}}))
  ;; (vim.cmd.colorscheme :rose-pine-dawn)
  )
