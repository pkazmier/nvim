-- ---------------------------------------------------------------------------
-- gruvbox-material colorscheme
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" }, { load = true })
  vim.g.gruvbox_material_float_style = "dim" -- if changed, update FloatTitle, MiniFilesTitle bg
  vim.g.gruvbox_material_background = "medium"

  Config.new_autocmd("ColorScheme", {
    pattern = "gruvbox-material",
    callback = function()
      -- stylua: ignore start
      local config  = vim.fn["gruvbox_material#get_configuration"]()
      local palette = vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
      local set_hl  = vim.fn["gruvbox_material#highlight"]

      set_hl("BlinkCmpMenu",                   palette.none,   palette.bg3)
      set_hl("BlinkCmpMenuBorder",             palette.none,   palette.bg3)
      set_hl("BlinkCmpDoc",                    palette.none,   palette.bg3)
      set_hl("BlinkCmpDocBorder",              palette.none,   palette.bg3)
      set_hl("BlinkCmpDocSeparator",           palette.none,   palette.bg3)
      set_hl("BlinkCmpSignatureHelp",          palette.none,   palette.bg5)
      set_hl("BlinkCmpSignatureHelpBorder",    palette.none,   palette.bg5)
      set_hl("FloatTitle",                     palette.none,   palette.bg_dim,         "bold")
      set_hl("MiniFilesTitle",                 palette.none,   palette.bg_dim)
      set_hl("LeapBackdrop",                   palette.bg5,    palette.none)
      set_hl("LeapLabel",                      palette.orange, palette.none,           "bold")
      set_hl("MiniPickMatchRanges",            palette.green,  palette.none,           "bold")
      set_hl("MiniTablineCurrent",             palette.blue,   palette.bg0,            "bold")
      set_hl("MiniTablineHidden",              palette.grey2,  palette.bg_statusline2)
      set_hl("MiniTablineModifiedCurrent",     palette.bg2,    palette.blue,           "bold")
      set_hl("MiniTablineModifiedHidden",      palette.bg2,    palette.grey2)
      set_hl("MiniTablineModifiedVisible",     palette.bg2,    palette.grey2,          "bold")
      set_hl("MiniTablineTabpagesection",      palette.bg0,    palette.aqua,           "bold")
      set_hl("MiniTablineVisible",             palette.grey2,  palette.bg_statusline2, "bold")
      set_hl("MiniStatuslineDirectory",        palette.grey0,  palette.bg_statusline1)
      set_hl("MiniStatuslineFilename",         palette.grey2,  palette.bg_statusline1, "bold")
      set_hl("MiniStatuslineFilenameModified", palette.blue,   palette.bg_statusline1, "bold")
      set_hl("MiniStatuslineInactive",         palette.grey0,  palette.bg_statusline1)
      set_hl("MiniJump2dDim",                  palette.bg5,    palette.none)
      set_hl("MiniJump2dSpot",                 palette.orange, palette.bg_dim,         "bold")
      set_hl("MiniJump2dSpotUnique",           palette.orange, palette.bg_dim,         "bold")
      set_hl("MiniJump2dSpotAhead",            palette.yellow, palette.bg_dim)
      set_hl("RenderMarkdownCodeBorder",       palette.none,   palette.bg3)
      set_hl("RenderMarkdownCode",             palette.none,   palette.bg_dim)
      set_hl("RenderMarkdownTableHead",        palette.bg3,    palette.none)
      set_hl("RenderMarkdownTableRow",         palette.bg3,    palette.none)
      set_hl("TreesitterContext",              palette.none,   palette.bg_dim)
      set_hl("TreesitterContextLineNumber",    palette.bg5,    palette.bg_dim)
      set_hl("TreesitterContextBottom",        palette.none,   palette.none, "underline", palette.bg1)
      --stylua: ignore end
    end,
  })
  -- vim.cmd.colorscheme("gruvbox-material")
end)
