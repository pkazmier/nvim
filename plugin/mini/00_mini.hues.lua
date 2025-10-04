local H = {}
MiniDeps.now(function()
  -- Apply custom highlights after loading a mini.hues based colorscheme.
  -- All of my mini.hues based colorschemes are prefixed with "minihues",
  -- but we cannot pattern match on "minihues*" because the seasonal ones
  -- in mini.hues are named "miniwinter", "minisummer", etc. So we match
  -- "mini*" and then exclude the two mini non-hues colorschemes included
  -- in mani.base16 ("minischeme" and "minicyan").
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = "mini*",
    callback = function(ev)
      if ev.match == "minischeme" or ev.match == "minicyan" then
        return
      end
      local p = require("mini.hues").get_palette()
      if p ~= nil then
        H.minihues_apply_custom_highlights(p)
      end
    end,
  })

  H.minihues_apply_custom_highlights = function(p)
    local hi = function(name, data)
      vim.api.nvim_set_hl(0, name, data)
    end

    hi("Title", { fg = p.accent, bg = nil, bold = true })

    -- stylua: ignore start
    -- Links to Comment by default, but that has italics
    hi("LeapBackdrop",                { link = "MiniJump2dDim" })

    -- I prefer italic fonts as I use fonts with beautiful italics.
    -- Some examples: Operator Mono, Berkeley Mono, PragmataPro, Radon
    hi("Comment",                    { fg = p.fg_mid2, bg = nil,         italic = true })
    hi("DiagnosticVirtualTextError", { fg = p.red,     bg = p.red_bg,    italic = true })
    hi("DiagnosticVirtualTextHint",  { fg = p.cyan,    bg = p.cyan_bg,   italic = true })
    hi("DiagnosticVirtualTextInfo",  { fg = p.blue,    bg = p.blue_bg,   italic = true })
    hi("DiagnosticVirtualTextOk",    { fg = p.green,   bg = p.green_bg,  italic = true })
    hi("DiagnosticVirtualTextWarn",  { fg = p.yellow,  bg = p.yellow_bg, italic = true })

    -- Highlight patterns for highlighting the whole line and hiding colon.
    -- See https://github.com/echasnovski/mini.nvim/discussions/783
    hi("MiniHipatternsFixmeBody",  { fg = p.red })
    hi("MiniHipatternsFixmeColon", { bg = p.red,    fg = p.red,    bold = true })
    hi("MiniHipatternsHackBody",   { fg = p.yellow })
    hi("MiniHipatternsHackColon",  { bg = p.yellow, fg = p.yellow, bold = true })
    hi("MiniHipatternsNoteBody",   { fg = p.cyan })
    hi("MiniHipatternsNoteColon",  { bg = p.cyan,   fg = p.cyan,   bold = true })
    hi("MiniHipatternsTodoBody",   { fg = p.blue })
    hi("MiniHipatternsTodoColon",  { bg = p.blue,   fg = p.blue,   bold = true })

    -- Bold matches in MiniPick
    hi("MiniPickMatchRanges",      { bg = nil, fg = p.cyan, bold = true})

    -- Highlight patterns for deemphasizing the directory name, so the
    -- filename is more prominent. Visually, this makes it faster to
    -- identify the name of the file.
    -- See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
    hi("MiniStatuslineDirectory",        { fg = p.fg_mid2, bg = p.accent_bg })
    hi("MiniStatuslineFilename",         { fg = p.fg_mid,  bg = p.accent_bg, bold = true })
    hi("MiniStatuslineFilenameModified", { fg = p.accent,  bg = p.accent_bg, bold = true })

    hi("RenderMarkdownCodeBorder",    { bg = p.bg_mid })
    hi("RenderMarkdownTableHead",     { fg = p.bg_mid2 })
    hi("RenderMarkdownTableRow",      { fg = p.bg_mid2 })
    hi("TreesitterContextLineNumber", { bg = p.bg_edge })
    hi("TreesitterContextBottom",     { sp = p.bg_mid, underdotted = true})

    -- I like my vertical split divider to be the same color as my inactive
    -- horizontal status bar color, so it's consistent both vertically and
    -- horizontally when laststatus=2.
    hi("VertSplit",    { fg = p.bg_edge, bg = nil })
    hi("WinSeparator", { fg = p.bg_edge, bg = nil })
    -- stylua: ignore end
  end

  vim.cmd.colorscheme("miniwinter")
end)
