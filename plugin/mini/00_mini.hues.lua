-- Disable modeline for this file because our template for the ghostty theme
-- includes a vim modeline, which would conflict with this file's modeline.
-- vim: nomodeline
local H = {}

MiniDeps.now(function()
  -- Apply custom highlights after loading a mini.hues based colorscheme.
  vim.api.nvim_create_autocmd("ColorScheme", {
    -- Only trigger for mini.hues based colorschemes and exclude mini.base16
    -- themes such as "minischeme" and "minicyan" as those are not generated
    -- from mini.hues palette.
    pattern = { "minihues*", "miniwinter", "minisummer", "miniautumn", "minispring", "randomhue" },
    callback = function(_)
      local p = require("mini.hues").get_palette()
      H.minihues_apply_custom_highlights(p)
    end,
  })

  H.minihues_apply_custom_highlights = function(p)
    if p == nil then
      return
    end

    local hi = function(name, data)
      vim.api.nvim_set_hl(0, name, data)
    end

    -- stylua: ignore start
    hi("Title",                          { fg = p.accent,  bg = nil,         bold = true })

    -- Links to Comment by default, but that has italics
    hi("LeapBackdrop",                   { link = "MiniJump2dDim" })

    -- I prefer italic fonts as I use fonts with beautiful italics.
    -- Some examples: Operator Mono, Berkeley Mono, PragmataPro, Radon
    hi("Comment",                        { fg = p.fg_mid2, bg = nil,         italic = true })
    hi("DiagnosticVirtualTextError",     { fg = p.red,     bg = p.red_bg,    italic = true })
    hi("DiagnosticVirtualTextHint",      { fg = p.cyan,    bg = p.cyan_bg,   italic = true })
    hi("DiagnosticVirtualTextInfo",      { fg = p.blue,    bg = p.blue_bg,   italic = true })
    hi("DiagnosticVirtualTextOk",        { fg = p.green,   bg = p.green_bg,  italic = true })
    hi("DiagnosticVirtualTextWarn",      { fg = p.yellow,  bg = p.yellow_bg, italic = true })

    -- Highlight patterns for highlighting the whole line and hiding colon.
    -- See https://github.com/echasnovski/mini.nvim/discussions/783
    hi("MiniHipatternsFixmeBody",        { fg = p.red })
    hi("MiniHipatternsHackBody",         { fg = p.yellow })
    hi("MiniHipatternsNoteBody",         { fg = p.cyan })
    hi("MiniHipatternsTodoBody",         { fg = p.blue })
    hi("MiniHipatternsFixmeColon",       { bg = p.red,     fg = p.red,       bold = true })
    hi("MiniHipatternsHackColon",        { bg = p.yellow,  fg = p.yellow,    bold = true })
    hi("MiniHipatternsNoteColon",        { bg = p.cyan,    fg = p.cyan,      bold = true })
    hi("MiniHipatternsTodoColon",        { bg = p.blue,    fg = p.blue,      bold = true })

    -- Bold matches in MiniPick
    hi("MiniPickMatchRanges",            { bg = nil,       fg = p.cyan,      bold = true})

    -- Dim inactive MiniStarter elements
    hi("MiniStarterInactive",            { link = "MiniJump2dDim" })

    -- Highlight patterns for deemphasizing the directory name, so the
    -- filename is more prominent. Visually, this makes it faster to
    -- identify the name of the file.
    -- See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
    hi("MiniStatuslineDirectory",        { fg = p.fg_mid2, bg = p.accent_bg })
    hi("MiniStatuslineFilename",         { fg = p.fg_mid,  bg = p.accent_bg, bold = true })
    hi("MiniStatuslineFilenameModified", { fg = p.accent,  bg = p.accent_bg, bold = true })

    hi("RenderMarkdownCodeBorder",       { bg = p.bg_mid })
    hi("RenderMarkdownTableHead",        { fg = p.bg_mid2 })
    hi("RenderMarkdownTableRow",         { fg = p.bg_mid2 })
    hi("TreesitterContextLineNumber",    { bg = p.bg_edge })
    hi("TreesitterContextBottom",        { sp = p.bg_mid,  underdotted = true})

    -- I like my vertical split divider to be the same color as my inactive
    -- horizontal status bar color, so it's consistent both vertically and
    -- horizontally when laststatus=2.
    hi("VertSplit",                      { fg = p.bg_edge, bg = nil })
    hi("WinSeparator",                   { fg = p.bg_edge, bg = nil })
    -- stylua: ignore end
  end

  -- Export current mini.hues palette to a neovim colorscheme file and
  -- a ghostty theme file. Prompts user for a name for the theme. This is
  -- useful if you generate a random colorscheme with mini.huas. Generated
  -- files are opened in a new split window for review and manual saving.
  Config.export_minihues_theme = function()
    local ok, theme_name = pcall(vim.fn.input, {
      prompt = "Enter name for color scheme: minihues-",
      cancelreturn = false,
    })
    if not ok or theme_name == false then
      return nil
    end

    local filename = "minihues-" .. theme_name
    local p = require("mini.hues").get_palette()

    -- Make a neovim minihues theme file
    H.render_to_buffer(H.minihues_path(filename), H.minihues_template, {
      name = filename,
      bg = p.bg,
      fg = p.fg,
    })
    vim.cmd("split")

    -- Make a ghostty theme file
    H.render_to_buffer(H.ghostty_path(filename), H.ghostty_template, {
      black = p.bg_mid,
      red = p.red,
      green = p.green,
      yellow = p.yellow,
      blue = p.azure,
      magenta = p.purple,
      cyan = p.cyan,
      white = p.fg_mid2,
      bright_black = p.bg_mid2,
      bright_red = p.red,
      bright_green = p.green,
      bright_yellow = p.yellow,
      bright_blue = p.azure,
      bright_magenta = p.purple,
      bright_cyan = p.cyan,
      bright_white = p.fg_mid,
      bg = p.bg,
      fg = p.fg,
      cursor_bg = p.azure,
      selection_bg = p.bg_mid2,
      selection_fg = p.fg,
    })
  end

  H.ghostty_path = function(theme_name)
    local dir = os.getenv("HOME")
    return string.format("%s/.config/ghostty/theme/%s", dir, theme_name)
  end

  H.minihues_path = function(theme_name)
    local dir = string.format("~/.config/%s/colors", os.getenv("NVIM_APPNAME") or "nvim")
    return string.format("%s/%s.lua", dir, theme_name)
  end

  H.render_to_buffer = function(filename, template, vars)
    local rendered = template:gsub("%${(.-)}", function(key)
      return vars[key] or ""
    end)
    vim.cmd(string.format("edit %s", filename))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(rendered, "\n"))
  end

  H.minihues_template = [[local hues = require("mini.hues")
hues.setup({
  background = "${bg}",
  foreground = "${fg}",
  accent = "azure",
})
vim.g.colors_name = "${name}"
]]

  H.ghostty_template = [[# Ghostty theme generated by mini.hues
palette = 0=${black}
palette = 1=${red}
palette = 2=${green}
palette = 3=${yellow}
palette = 4=${blue}
palette = 5=${magenta}
palette = 6=${cyan}
palette = 7=${white}
palette = 8=${bright_black}
palette = 9=${bright_red}
palette = 10=${bright_green}
palette = 11=${bright_yellow}
palette = 12=${bright_blue}
palette = 13=${bright_magenta}
palette = 14=${bright_cyan}
palette = 15=${bright_white}

background = ${bg}
foreground = ${fg}
cursor-color = ${cursor_bg}
selection-background = ${selection_bg}
selection-foreground = ${selection_fg}

# vim: ft=config
]]

  vim.cmd.colorscheme("miniwinter")
end)
