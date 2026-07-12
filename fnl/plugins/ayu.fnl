;; ---------------------------------------------------------------------------
;; ayu colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; ayu
  (vim.pack.add [{:src "https://github.com/Shatur/neovim-ayu"}])
  (local ayu (require :ayu))
  (ayu.setup {:mirage true
              :terminal true
              :overrides (fn []
                           (local c (require :ayu.colors))
                           (local overrides
                                  {:CursorLineNr                   {:fg c.accent :bg c.bg :bold true}
                                   :FloatTitle                     {:fg c.tag :bold true}
                                   :LineNr                         {:fg c.guide_active}
                                   ;; Now that 'pumborder' exists, use same styling for other floats
                                   :Pmenu                          {:fg c.fg :bg c.bg}
                                   :PmenuBorder                    {:fg c.comment :bg c.bg}
                                   :PmenuMatch                     {:fg c.regexp :bold true}
                                   :PmenuSel                       {:bg c.selection_bg :reverse false :bold true}
                                   ;; Use reverse text for diagnostics
                                   :DiagnosticVirtualTextError     {:bg c.error :fg c.line :italic true}
                                   :DiagnosticVirtualTextWarn      {:bg c.keyword :fg c.line :italic true}
                                   :DiagnosticVirtualTextInfo      {:bg c.tag :fg c.line :italic true}
                                   :DiagnosticVirtualTextHint      {:bg c.regexp :fg c.line :italic true}
                                   ;; I prefer dimming background and brighter labels
                                   :LeapBackdrop                   {:link :MiniJump2dDim}
                                   :LeapLabel                      {:fg c.accent :bold true}
                                   ;; Bold current line in MiniFiles
                                   :MiniFilesCursorLine            {:fg nil :bg c.selection_bg :bold true}
                                   :MiniFilesTitle                 {:fg c.tag :bg c.panel_bg :bold false}
                                   :MiniFilesTitleFocused          {:fg c.tag :bg c.panel_bg :bold true}
                                   ;; Bold matches and current line in MiniPick
                                   :MiniPickMatchCurrent           {:fg nil :bg c.selection_bg :bold true}
                                   :MiniPickMatchMarked            {:fg nil :bg c.gutter_normal :bold true}
                                   :MiniPickMatchRanges            {:fg c.regexp :bold true}
                                   :MiniPickPrompt                 {:fg c.fg :bold true}
                                   :MiniPickPromptPrefix           {:fg c.tag :bold true}
                                   ;; Dim inactive MiniStarter elements
                                   :MiniStarterInactive            {:link :MiniJump2dDim}
                                   :MiniStarterSection             {:fg c.keyword :bold true}
                                   :MiniStarterHeader              {:fg c.tag :bold true}
                                   ;; Highlight patterns for deemphasizing the directory name, so the
                                   ;; filename is more prominent. Visually, this makes it faster to
                                   ;; identify the name of the file.
                                   ;; See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
                                   :MiniStatuslineDirectory        {:fg c.lsp_inlay_hint :bg c.selection_inactive}
                                   :MiniStatuslineFilename         {:fg c.fg :bg c.selection_inactive :bold true}
                                   :MiniStatuslineFilenameModified {:fg c.fg :bg c.selection_inactive :bold true}
                                   :MiniStatuslineDevinfo          {:fg c.fg :bg c.selection_bg}
                                   :MiniStatuslineFileinfo         {:fg c.fg :bg c.selection_bg}
                                   :StatusLine                     {:fg c.fg :bg c.selection_inactive}
                                   :StatusLineNC                   {:fg c.fg :bg c.panel_border}
                                   :RenderMarkdownCode             {:bg c.selection_inactive}
                                   :RenderMarkdownCodeBorder       {:bg c.selection_bg}
                                   :RenderMarkdownCodeInline       {:fg c.tag :bg c.selection_inactive}
                                   :RenderMarkdownTableHead        {:fg c.selection_bg}
                                   :RenderMarkdownTableRow         {:fg c.selection_bg}
                                   ;; Extend the context highlighting to line numbers as well
                                   :TreesitterContext              {:bg c.selection_inactive}
                                   :TreesitterContextBottom        {:sp c.panel_bg :underline true}
                                   :TreesitterContextLineNumber    {:fg c.guide_active :bg c.selection_inactive}})
                           ;; "@..." keys are set via `tset` because fnlfmt rewrites literal "@..."
                           ;; table keys into :@... keywords, which hotpot's fennel cannot parse.
                           (tset overrides "@markup.heading"                        {:fg c.keyword :bold true})
                           (tset overrides "@markup.heading.1"                      {:fg c.accent :bold true})
                           (tset overrides "@markup.heading.2"                      {:fg c.keyword :bold true})
                           (tset overrides "@markup.heading.3"                      {:fg c.markup :bold true})
                           (tset overrides "@markup.heading.4"                      {:fg c.entity :bold true})
                           (tset overrides "@markup.heading.5"                      {:fg c.regexp :bold true})
                           (tset overrides "@markup.heading.6"                      {:fg c.string :bold true})
                           (tset overrides "@markup.strong"                         {:fg c.keyword :bold true})
                           (tset overrides "@markup.italic"                         {:fg c.keyword :italic true})
                           (tset overrides "@markup.quote"                          {:fg c.constant :italic true})
                           (tset overrides "@markup.raw"                            {:fg c.tag :bg c.selection_inactive})
                           (tset overrides "@markup.list"                           {:fg c.vcs_added})
                           (tset overrides "@markup.raw.block"                      {:fg c.tag})
                           (tset overrides "@module"                                {:fg c.fg})
                           (tset overrides "@string.documentation"                  {:fg c.lsp_inlay_hint})
                           (tset overrides "@variable.builtin"                      {:fg c.fg})
                           (tset overrides "@lsp.type.variable"                     {:link "@lsp"})
                           (tset overrides "@lsp.typemod.class.defaultLibrary"      {:link "@type.builtin"})
                           (tset overrides "@lsp.typemod.enum.defaultLibrary"       {:link "@type.builtin"})
                           (tset overrides "@lsp.typemod.enumMember.defaultLibrary" {:link "@constant.builtin"})
                           (tset overrides "@lsp.typemod.function.defaultLibrary"   {:link "@function.builtin"})
                           (tset overrides "@lsp.typemod.keyword.async"             {:link "@keyword.coroutine"})
                           (tset overrides "@lsp.typemod.keyword.injected"          {:link "@keyword"})
                           (tset overrides "@lsp.typemod.macro.defaultLibrary"      {:link "@function.builtin"})
                           (tset overrides "@lsp.typemod.method.defaultLibrary"     {:link "@function.builtin"})
                           (tset overrides "@lsp.typemod.operator.injected"         {:link "@operator"})
                           (tset overrides "@lsp.typemod.string.injected"           {:link "@string"})
                           (tset overrides "@lsp.typemod.struct.defaultLibrary"     {:link "@type.builtin"})
                           (tset overrides "@lsp.typemod.variable.callable"         {:link "@function"})
                           (tset overrides "@lsp.typemod.variable.defaultLibrary"   {:link "@variable.builtin"})
                           (tset overrides "@lsp.typemod.variable.injected"         {:link "@variable"})
                           (tset overrides "@lsp.typemod.variable.static"           {:link "@constant"})
                           overrides)})
  ;; (vim.cmd.colorscheme :ayu)
  )
