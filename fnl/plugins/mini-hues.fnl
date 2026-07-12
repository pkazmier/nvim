;; ---------------------------------------------------------------------------
;; mini.hues
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)
(local H {})

(with-now! ; mini.hues
  (local autocmds (require :config.autocmds))
  (local hues (require :mini.hues))
  (autocmds.new [:ColorScheme]
                {:pattern [:minihues*
                           :miniwinter
                           :minisummer
                           :miniautumn
                           :minispring
                           :randomhue]
                 :callback (fn []
                             (H.apply_custom_highlights (hues.get_palette)))}))

;; fnlfmt: skip
(fn H.apply_custom_highlights [p]
  (when p
    (fn hi [name data] (vim.api.nvim_set_hl 0 name data))

    ;; I prefer bold titles
    (hi :Title {:fg p.accent :bg nil :bold true})

    ;; Links to Comment by default, but that has italics
    (hi :LeapBackdrop {:link :MiniJump2dDim})

    ;; I prefer italic fonts as I use fonts with beautiful italics.
    ;; Some examples: Operator Mono, Berkeley Mono, PragmataPro, Radon
    (hi :Comment                    {:fg p.fg_mid2 :bg nil         :italic true})
    (hi :DiagnosticVirtualTextError {:fg p.red     :bg p.red_bg    :italic true})
    (hi :DiagnosticVirtualTextHint  {:fg p.cyan    :bg p.cyan_bg   :italic true})
    (hi :DiagnosticVirtualTextInfo  {:fg p.blue    :bg p.blue_bg   :italic true})
    (hi :DiagnosticVirtualTextOk    {:fg p.green   :bg p.green_bg  :italic true})
    (hi :DiagnosticVirtualTextWarn  {:fg p.yellow  :bg p.yellow_bg :italic true})

    ;; Dim inactive MiniStarter elements
    (hi :MiniStarterInactive {:link :MiniJump2dDim})

    ;; Highlight patterns for deemphasizing the directory name, so the
    ;; filename is more prominent. Visually, this makes it faster to
    ;; identify the name of the file.
    ;; See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
    (hi :MiniStatuslineDirectory        {:fg p.fg_mid2 :bg p.accent_bg})
    (hi :MiniStatuslineFilename         {:fg p.fg_mid  :bg p.accent_bg :bold true})
    (hi :MiniStatuslineFilenameModified {:fg p.accent  :bg p.accent_bg :bold true})

    ;; Other groups
    (hi :RenderMarkdownCodeBorder    {:bg p.bg_mid})
    (hi :RenderMarkdownTodo          {:fg p.azure})
    (hi :RenderMarkdownTableHead     {:fg p.bg_mid2})
    (hi :RenderMarkdownTableRow      {:fg p.bg_mid2})
    (hi :RenderMarkdownLink          {:fg p.yellow})
    (hi :RenderMarkdownWikiLink      {:fg p.yellow})
    (hi :TreesitterContext           {:bg p.bg_mid})
    (hi :TreesitterContextBottom     {:sp p.bg_edge :underline true})
    (hi :TreesitterContextLineNumber {:bg p.bg_mid})

    ;; I like my vertical split divider to be the same color as my inactive
    ;; horizontal status bar color, so it's consistent both vertically and
    ;; horizontally when laststatus=2.
    (hi :WinSeparator {:fg p.bg_edge :bg nil})

    (hi "@markup.heading"   {:fg p.accent :bold true})
    (hi "@markup.heading.1" {:fg p.orange :bold true})
    (hi "@markup.heading.2" {:fg p.yellow :bold true})
    (hi "@markup.heading.3" {:fg p.green  :bold true})
    (hi "@markup.heading.4" {:fg p.cyan   :bold true})
    (hi "@markup.heading.5" {:fg p.azure  :bold true})
    (hi "@markup.heading.6" {:fg p.blue   :bold true})
    (hi "@markup.strong"    {:fg p.accent :bold true})
    (hi "@markup.italic"    {:fg p.accent :italic true})))
