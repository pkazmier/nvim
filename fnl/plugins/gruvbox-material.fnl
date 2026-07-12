;; ---------------------------------------------------------------------------
;; gruvbox-material colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; gruvbox-material
  (vim.pack.add [{:src "https://github.com/sainnhe/gruvbox-material"}])
  ;; if changed, update FloatTitle, MiniFilesTitle bg
  (set vim.g.gruvbox_material_float_style :dim)
  (set vim.g.gruvbox_material_background :medium)
  (local autocmds (require :config.autocmds))
  (autocmds.new :ColorScheme
                {:pattern :gruvbox-material
                 :callback (fn []
                             (local config ((. vim.fn "gruvbox_material#get_configuration")))
                             (local palette ((. vim.fn "gruvbox_material#get_palette") config.background config.foreground config.colors_override))
                             (local set-hl (. vim.fn "gruvbox_material#highlight"))
                             (set-hl :BlinkCmpMenu                   palette.none   palette.bg3)
                             (set-hl :BlinkCmpMenuBorder             palette.none   palette.bg3)
                             (set-hl :BlinkCmpDoc                    palette.none   palette.bg3)
                             (set-hl :BlinkCmpDocBorder              palette.none   palette.bg3)
                             (set-hl :BlinkCmpDocSeparator           palette.none   palette.bg3)
                             (set-hl :BlinkCmpSignatureHelp          palette.none   palette.bg5)
                             (set-hl :BlinkCmpSignatureHelpBorder    palette.none   palette.bg5)
                             (set-hl :FloatTitle                     palette.none   palette.bg_dim         :bold)
                             (set-hl :MiniFilesTitle                 palette.none   palette.bg_dim)
                             (set-hl :LeapBackdrop                   palette.bg5    palette.none)
                             (set-hl :LeapLabel                      palette.orange palette.none           :bold)
                             (set-hl :MiniPickMatchRanges            palette.green  palette.none           :bold)
                             (set-hl :MiniTablineCurrent             palette.blue   palette.bg0            :bold)
                             (set-hl :MiniTablineHidden              palette.grey2  palette.bg_statusline2)
                             (set-hl :MiniTablineModifiedCurrent     palette.bg2    palette.blue           :bold)
                             (set-hl :MiniTablineModifiedHidden      palette.bg2    palette.grey2)
                             (set-hl :MiniTablineModifiedVisible     palette.bg2    palette.grey2          :bold)
                             (set-hl :MiniTablineTabpagesection      palette.bg0    palette.aqua           :bold)
                             (set-hl :MiniTablineVisible             palette.grey2  palette.bg_statusline2 :bold)
                             (set-hl :MiniStatuslineDirectory        palette.grey0  palette.bg_statusline1)
                             (set-hl :MiniStatuslineFilename         palette.grey2  palette.bg_statusline1 :bold)
                             (set-hl :MiniStatuslineFilenameModified palette.blue   palette.bg_statusline1 :bold)
                             (set-hl :MiniStatuslineInactive         palette.grey0  palette.bg_statusline1)
                             (set-hl :MiniJump2dDim                  palette.bg5    palette.none)
                             (set-hl :MiniJump2dSpot                 palette.orange palette.bg_dim         :bold)
                             (set-hl :MiniJump2dSpotUnique           palette.orange palette.bg_dim         :bold)
                             (set-hl :MiniJump2dSpotAhead            palette.yellow palette.bg_dim)
                             (set-hl :RenderMarkdownCodeBorder       palette.none   palette.bg3)
                             (set-hl :RenderMarkdownCode             palette.none   palette.bg_dim)
                             (set-hl :RenderMarkdownTableHead        palette.bg3    palette.none)
                             (set-hl :RenderMarkdownTableRow         palette.bg3    palette.none)
                             (set-hl :TreesitterContext              palette.none   palette.bg_dim)
                             (set-hl :TreesitterContextLineNumber    palette.bg5    palette.bg_dim)
                             (set-hl :TreesitterContextBottom        palette.none   palette.none           :underline palette.bg1))})
  ;; (vim.cmd.colorscheme :gruvbox-material)
  )
