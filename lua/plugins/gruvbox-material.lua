vim.g.gruvbox_material_float_style = "dim"

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("custom_highlights_gruvboxmaterial", {}),
  pattern = "gruvbox-material",
  callback = function()
    -- stylua: ignore start
    local config  = vim.fn["gruvbox_material#get_configuration"]()
    local palette = vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
    local set_hl  = vim.fn["gruvbox_material#highlight"]

    set_hl("MiniPickPrompt",                 palette.blue,   config.float_style == "dim" and palette.bg_dim or palette.bg3)
    set_hl("MiniFilesFile",                  palette.fg1,    palette.none)
    set_hl("MiniTablineCurrent",             palette.blue,   palette.bg3,            "bold")
    set_hl("MiniTablineHidden",              palette.grey2,  palette.bg3)
    set_hl("MiniTablineModifiedCurrent",     palette.bg2,    palette.blue,           "bold")
    set_hl("MiniTablineModifiedHidden",      palette.bg2,    palette.grey2)
    set_hl("MiniTablineModifiedVisible",     palette.bg2,    palette.grey2,          "bold")
    set_hl("MiniTablineTabpagesection",      palette.bg0,    palette.aqua,           "bold")
    set_hl("MiniTablineVisible",             palette.grey2,  palette.bg3,            "bold")
    set_hl("MiniHipatternsFixmeBody",        palette.red,    palette.bg0)
    set_hl("MiniHipatternsFixmeColon",       palette.red,    palette.red,            "bold")
    set_hl("MiniHipatternsHackBody",         palette.yellow, palette.bg0)
    set_hl("MiniHipatternsHackColon",        palette.yellow, palette.yellow,         "bold")
    set_hl("MiniHipatternsNoteBody",         palette.blue,   palette.bg0)
    set_hl("MiniHipatternsNoteColon",        palette.blue,   palette.blue,           "bold")
    set_hl("MiniHipatternsTodoBody",         palette.green,  palette.bg0)
    set_hl("MiniHipatternsTodoColon",        palette.green,  palette.green,          "bold")
    set_hl("MiniStatuslineDirectory",        palette.grey0,  palette.bg_statusline1)
    set_hl("MiniStatuslineFilename",         palette.grey2,  palette.bg_statusline1, "bold")
    set_hl("MiniStatuslineFilenameModified", palette.blue,   palette.bg_statusline1, "bold")
    set_hl("MiniStatuslineInactive",         palette.grey0,  palette.bg_statusline1)
    --stylua: ignore end
  end,
})
