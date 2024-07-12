vim.g.everforest_float_style = "dim"
vim.g.everforest_background = "hard"

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("custom_highlights_everforest", {}),
  pattern = "everforest",
  callback = function()
    -- stylua: ignore start
    local config  = vim.fn['everforest#get_configuration']()
    local palette = vim.fn['everforest#get_palette'](config.background, config.colors_override)
    local set_hl  = vim.fn['everforest#highlight']

    set_hl("KazCodeBlock",                   palette.none,   config.float_style == "dim" and palette.bg_dim or palette.bg2)
    set_hl("MiniPickMatchRanges",            palette.green,  palette.none,   "bold")
    set_hl("MiniTablineFill",                palette.none,   palette.bg1)
    set_hl("MiniTablineCurrent",             palette.blue,   palette.bg0,    "bold")
    set_hl("MiniTablineHidden",              palette.grey2,  palette.bg2)
    set_hl("MiniTablineModifiedCurrent",     palette.bg1,    palette.blue,   "bold")
    set_hl("MiniTablineModifiedHidden",      palette.bg1,    palette.grey2)
    set_hl("MiniTablineModifiedVisible",     palette.bg1,    palette.grey2,  "bold")
    set_hl("MiniTablineTabpagesection",      palette.bg0,    palette.aqua,   "bold")
    set_hl("MiniTablineVisible",             palette.grey2,  palette.bg2,    "bold")
    set_hl("MiniHipatternsFixmeBody",        palette.red,    palette.bg0)
    set_hl("MiniHipatternsFixmeColon",       palette.red,    palette.red,    "bold")
    set_hl("MiniHipatternsHackBody",         palette.yellow, palette.bg0)
    set_hl("MiniHipatternsHackColon",        palette.yellow, palette.yellow, "bold")
    set_hl("MiniHipatternsNoteBody",         palette.blue,   palette.bg0)
    set_hl("MiniHipatternsNoteColon",        palette.blue,   palette.blue,   "bold")
    set_hl("MiniHipatternsTodoBody",         palette.green,  palette.bg0)
    set_hl("MiniHipatternsTodoColon",        palette.green,  palette.green,  "bold")
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
    --stylua: ignore end
  end,
})
