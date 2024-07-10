vim.g.edge_float_style = "dim"
vim.g.edge_background = "hard"

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("custom_highlights_edge", {}),
  pattern = "edge",
  callback = function()
    -- stylua: ignore start
    local config  = vim.fn['edge#get_configuration']()
    local palette = vim.fn['edge#get_palette'](config.style, config.dim_foreground, config.colors_override)
    local set_hl  = vim.fn['edge#highlight']

    set_hl("KazCodeBlock",                   palette.none,     config.float_style == "dim" and palette.bg_dim or palette.bg2)
    set_hl("MiniPickPrompt",                 palette.blue,     config.float_style == "dim" and palette.bg_dim or palette.bg2)
    set_hl("MiniPickMatchRanges",            palette.blue,     palette.none,   "bold")
    set_hl("MiniFilesFile",                  palette.fg,       palette.none)
    set_hl("MiniTablineFill",                palette.none,     palette.bg1)
    set_hl("MiniTablineCurrent",             palette.blue,     palette.bg0,    "bold")
    set_hl("MiniTablineHidden",              palette.grey,     palette.bg3)
    set_hl("MiniTablineModifiedCurrent",     palette.bg1,      palette.blue,   "bold")
    set_hl("MiniTablineModifiedHidden",      palette.bg1,      palette.grey)
    set_hl("MiniTablineModifiedVisible",     palette.bg1,      palette.grey,   "bold")
    set_hl("MiniTablineTabpagesection",      palette.bg0,      palette.green,  "bold")
    set_hl("MiniTablineVisible",             palette.grey,     palette.bg3,    "bold")
    set_hl("MiniHipatternsFixmeBody",        palette.red,      palette.bg0)
    set_hl("MiniHipatternsFixmeColon",       palette.red,      palette.red,    "bold")
    set_hl("MiniHipatternsHackBody",         palette.yellow,   palette.bg0)
    set_hl("MiniHipatternsHackColon",        palette.yellow,   palette.yellow, "bold")
    set_hl("MiniHipatternsNoteBody",         palette.blue,     palette.bg0)
    set_hl("MiniHipatternsNoteColon",        palette.blue,     palette.blue,   "bold")
    set_hl("MiniHipatternsTodoBody",         palette.green,    palette.bg0)
    set_hl("MiniHipatternsTodoColon",        palette.green,    palette.green,  "bold")
    set_hl("MiniStatuslineDirectory",        palette.grey,     palette.bg1)
    set_hl("MiniStatuslineFilename",         palette.grey,     palette.bg1,    "bold")
    set_hl("MiniStatuslineFilenameModified", palette.blue,     palette.bg1,    "bold")
    set_hl("MiniStatuslineInactive",         palette.grey_dim, palette.bg1)
    set_hl("MiniStatuslineDevInfo",          palette.grey,     palette.bg3)
    set_hl("MiniStatuslineFileInfo",         palette.grey,     palette.bg3)
    set_hl("MiniJump2dDim",                  palette.grey_dim, palette.none)
    set_hl("MiniJump2dSpot",                 palette.blue,     palette.bg_dim, "bold")
    set_hl("MiniJump2dSpotUnique",           palette.blue,     palette.bg_dim, "bold")
    set_hl("MiniJump2dSpotAhead",            palette.purple,   palette.bg_dim)
    --stylua: ignore end
  end,
})
