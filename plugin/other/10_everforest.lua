-- ---------------------------------------------------------------------------
-- everforest colorscheme
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ "https://github.com/sainnhe/everforest" })
  vim.g.everforest_float_style = "dim" -- if changed, update FloatTitle, MiniFilesTitle bg
  vim.g.everforest_background = "medium"

  Config.new_autocmd("ColorScheme", {
    pattern = "everforest",
    callback = function()
      -- stylua: ignore start
      local config  = vim.fn['everforest#get_configuration']()
      local palette = vim.fn['everforest#get_palette'](config.background, config.colors_override)
      local set_hl  = vim.fn['everforest#highlight']

      set_hl("BlinkCmpMenu",                   palette.none,   palette.bg3)
      set_hl("BlinkCmpMenuBorder",             palette.none,   palette.bg3)
      set_hl("BlinkCmpDoc",                    palette.none,   palette.bg3)
      set_hl("BlinkCmpDocBorder",              palette.none,   palette.bg3)
      set_hl("BlinkCmpDocSeparator",           palette.none,   palette.bg3)
      set_hl("BlinkCmpSignatureHelp",          palette.none,   palette.bg5)
      set_hl("BlinkCmpSignatureHelpBorder",    palette.none,   palette.bg5)
      set_hl("FloatTitle",                     palette.none,   palette.bg_dim, "bold")
      set_hl("MiniFilesTitle",                 palette.none,   palette.bg_dim)
      set_hl("MiniPickMatchRanges",            palette.green,  palette.none,   "bold")
      set_hl("MiniTablineFill",                palette.none,   palette.bg1)
      set_hl("MiniTablineCurrent",             palette.blue,   palette.bg0,    "bold")
      set_hl("MiniTablineHidden",              palette.grey2,  palette.bg2)
      set_hl("MiniTablineModifiedCurrent",     palette.bg1,    palette.blue,   "bold")
      set_hl("MiniTablineModifiedHidden",      palette.bg1,    palette.grey2)
      set_hl("MiniTablineModifiedVisible",     palette.bg1,    palette.grey2,  "bold")
      set_hl("MiniTablineTabpagesection",      palette.bg0,    palette.aqua,   "bold")
      set_hl("MiniTablineVisible",             palette.grey2,  palette.bg2,    "bold")
      set_hl("MiniStatuslineDirectory",        palette.grey0,  palette.bg1)
      set_hl("MiniStatuslineFilename",         palette.grey2,  palette.bg1,    "bold")
      set_hl("MiniStatuslineFilenameModified", palette.blue,   palette.bg1,    "bold")
      set_hl("MiniStatuslineInactive",         palette.grey0,  palette.bg1)
      set_hl("MiniStatuslineDevinfo",          palette.grey2,  palette.bg3)
      set_hl("MiniStatuslineFileinfo",         palette.grey2,  palette.bg3)
      set_hl("MiniJump2dDim",                  palette.bg5,    palette.none)
      set_hl("MiniJump2dSpot",                 palette.orange, palette.bg_dim, "bold")
      set_hl("MiniJump2dSpotUnique",           palette.orange, palette.bg_dim, "bold")
      set_hl("MiniJump2dSpotAhead",            palette.yellow, palette.bg_dim)
      set_hl("RenderMarkdownCodeBorder",       palette.none,   palette.bg2)
      set_hl("RenderMarkdownCode",             palette.none,   palette.bg_dim)
      set_hl("RenderMarkdownTableHead",        palette.bg3,    palette.none)
      set_hl("RenderMarkdownTableRow",         palette.bg3,    palette.none)
      set_hl("TreesitterContext",              palette.none,   palette.bg_dim)
      set_hl("TreesitterContextLineNumber",    palette.bg5,    palette.bg_dim)
      set_hl("TreesitterContextBottom",        palette.none,   palette.none, "underline", palette.bg1)
      --stylua: ignore end
    end,
  })
end)
