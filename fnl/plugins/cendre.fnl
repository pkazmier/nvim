;; ---------------------------------------------------------------------------
;; cendre colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

;; fnlfmt: skip
(with-now! ; cendre
  (vim.pack.add [{:src "https://github.com/Aejkatappaja/cendre"}])
  (local cendre (require :cendre))
  (cendre.setup
    {:background :hard
     :on_highlights (fn [hl c]
                      (set hl.PmenuBorder                 {:fg c.bg3 :bg c.bg_deep})
                      ;; (set hl.PmenuBorder                 {:fg c.bg3 :bg c.bg1})
                      (set hl.PmenuMatch                  {:fg c.ember :bold true})
                      (set hl.Pmenu                       {:fg c.fg :bg c.bg_deep})
                      (set hl.PmenuKind                   {:bg c.bg_deep})
                      (set hl.PmenuExtra                  {:bg c.bg_deep})
                      (set hl.PmenuSel                    {:bg c.bg2 :bold true})
                      (set hl.PmenuExtraSel               {:bg c.bg2 :bold true})
                      (set hl.PmenuKindSel                {:bg c.bg2 :bold true})

                      (set hl.MiniClueDescGroup           {:fg c.frost})
                      (set hl.MiniClueDescSingle          {:fg c.fg})
                      (set hl.MiniClueNextKey             {:fg c.ember})
                      (set hl.MiniClueNextKeyWithPostkeys {:fg c.sap})
                      (set hl.MiniClueSeparator           {:fg c.bg3})

                      (set hl.MiniCmdlinePeekLineNr       {:fg c.ember})
                      (set hl.MiniCmdlinePeekSign         {:fg c.info})
                      (set hl.MiniCmdlinePeekSep          {:fg c.gutter :bg c.bg_dim})

                      (set hl.MiniDiffSignAdd             {:fg c.ok})
                      (set hl.MiniDiffSignChange          {:fg c.info})
                      (set hl.MiniDiffSignDelete          {:fg c.error})

                      (set hl.MiniFilesCursorLine         {:bg c.bg2 :bold true})
                      (set hl.MiniFilesTitle              {:fg c.comment :bold true})
                      (set hl.MiniFilesTitleFocused       {:fg c.ember :bold true})

                      (set hl.MiniIconsAzure              {:fg c.frost})
                      (set hl.MiniIconsBlue               {:fg c.info})
                      (set hl.MiniIconsCyan               {:fg c.hint})
                      (set hl.MiniIconsGreen              {:fg c.sap})
                      (set hl.MiniIconsGrey               {:fg c.fg_dim})
                      (set hl.MiniIconsOrange             {:fg c.ember})
                      (set hl.MiniIconsPurple             {:fg c.potassium})
                      (set hl.MiniIconsRed                {:fg c.cinder})
                      (set hl.MiniIconsYellow             {:fg c.brass})

                      (set hl.MiniInputPrompt             {:fg c.ember :bold true})
                      (set hl.MiniInputCaret              {:fg c.cinder :bold true})

                      (set hl.MiniMapNormal               {:fg c.fg_dim :bg c.bg_deep})

                      (set hl.MiniPickMatchCurrent        {:bg c.bg2 :bold true})
                      (set hl.MiniPickMatchRanges         {:fg c.ember :bold true})
                      (set hl.MiniPickMatchMarked         {:bg c.bg4})
                      (set hl.MiniPickPrompt              {:fg c.fg})
                      (set hl.MiniPickPromptCaret         {:fg c.cinder})
                      (set hl.MiniPickPromptPrefix        {:fg c.ember})
                      (set hl.MiniPickHeader              {:fg c.brass :bold true})

                      (set hl.MiniStarterFooter           {:fg c.comment :italic true})
                      (set hl.MiniStarterInactive         {:fg c.comment})
                      (set hl.MiniStarterItemPrefix       {:fg c.cinder})
                      (set hl.MiniStarterQuery            {:fg c.ember})
                      (set hl.MiniStarterSection          {:fg c.brass})

                      (set hl.MiniStatuslineModeNormal    {:fg c.bg0 :bg c.ember :bold true})
                      (set hl.MiniStatuslineModeInsert    {:fg c.bg0 :bg c.ok :bold true})
                      (set hl.MiniStatuslineModeVisual    {:fg c.bg0 :bg c.info :bold true})
                      (set hl.MiniStatuslineModeReplace   {:fg c.bg0 :bg c.error :bold true})
                      (set hl.MiniStatuslineModeCommand   {:fg c.bg0 :bg c.brass :bold true})
                      (set hl.MiniStatuslineModeOther     {:fg c.bg0 :bg c.hint :bold true})
                      (set hl.MiniStatuslineDevInfo       {:fg c.fg :bg c.bg3})
                      (set hl.MiniStatuslineFileInfo      {:fg c.fg :bg c.bg3})
                      (set hl.MiniStatuslineDirectory     {:fg c.fg_dim :bg c.bg2})
                      (set hl.MiniStatuslineFilename      {:fg c.fg_dim :bg c.bg2 })
                      (set hl.MiniStatuslineFilenameModified {:fg c.fg_dim :bg c.bg2 })
;;                       (set hl.MiniStatuslineFilename      {:fg c.fg_dim :bg c.bg2 :bold true})
;;                       (set hl.MiniStatuslineFilenameModified {:fg c.fg_dim :bg c.bg2 :bold true})
                      (set hl.MiniStatuslineInactive      {:fg c.comment :bg c.bg2})

                      (set hl.MiniTablineFill             {:bg c.bg2})
                      (set hl.MiniTablineCurrent          {:fg c.fg :bg c.bg2 :bold true})
                      (set hl.MiniTablineModifiedCurrent  {:bg c.fg :fg c.bg2 :bold true})
                      (set hl.MiniTablineVisible          {:fg c.fg_dim :bg c.bg2 :bold true})
                      (set hl.MiniTablineModifiedVisible  {:bg c.fg_dim :fg c.bg2 :bold true})
                      (set hl.MiniTablineHidden           {:fg c.comment :bg c.bg2})
                      (set hl.MiniTablineModifiedHidden   {:bg c.comment :fg c.bg2})

                      (set hl.MiniTrailspace              {:bg c.bg3})

                      ;; Use these when NormalFloat fg is fg_dim
                      (set hl.NormalFloat                 {:fg c.fg_dim :bg c.bg_deep})
                      (set hl.Pmenu                       {:fg c.fg_dim :bg c.bg_deep})
                      (set hl.PmenuMatch                  {:fg c.ember})
                      (set hl.PmenuSel                    {:fg c.fg :bg c.bg2 :bold true})
                      (set hl.MiniClueDescSingle          {:fg c.fg_dim})
                      (set hl.MiniFilesCursorLine         {:bg c.bg2 :bold true})
                      (set hl.MiniPickMatchRanges         {:fg c.ember})
                      (set hl.MiniPickMatchCurrent        {:bg c.bg2 :bold true})

                      (set hl.MiniStatuscolumnSep         {:fg c.bg3})
                      (set hl.MiniStatuscolumnSepCursor   {:fg c.cinder})

                      )})
  (vim.cmd.colorscheme :cendre))
