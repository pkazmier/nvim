-- ---------------------------------------------------------------------------
-- ayu colorscheme
-- ---------------------------------------------------------------------------

Config.now(function()
  vim.pack.add({ "https://github.com/Shatur/neovim-ayu" }, { load = true })
  require("ayu").setup({
    mirage = true,
    terminal = true,
    overrides = function()
      local c = require("ayu.colors")
      -- stylua: ignore
      return {
        CursorLineNr                   = { fg = c.accent, bg = c.bg, bold = true },
        FloatTitle                     = { fg = c.tag,    bold = true },
        LineNr                         = { fg = c.guide_active },

        -- Now that 'pumborder' exists, use same styling for other floats
        Pmenu                          = { fg = c.fg,           bg = c.bg },
        PmenuBorder                    = { fg = c.comment,      bg = c.bg },
        PmenuMatch                     = { fg = c.regexp,       bold = true },
        PmenuSel                       = { bg = c.selection_bg, reverse = false, bold = true },

        -- Use reverse text for diagnostics
        DiagnosticVirtualTextError     = { bg = c.error,   fg = c.line, italic = true },
        DiagnosticVirtualTextWarn      = { bg = c.keyword, fg = c.line, italic = true },
        DiagnosticVirtualTextInfo      = { bg = c.tag,     fg = c.line, italic = true },
        DiagnosticVirtualTextHint      = { bg = c.regexp,  fg = c.line, italic = true },

        -- I prefer dimming background and brighter labels
        LeapBackdrop                   = { link = "MiniJump2dDim" },
        LeapLabel                      = { fg = c.accent, bold = true },

        -- Bold current line in MiniFiles
        MiniFilesCursorLine            = { fg = nil,        bg = c.selection_bg, bold = true },
        MiniFilesTitleFocused          = { fg = c.panel_bg, bg = c.tag,          bold = true },

        -- Highlight patterns for highlighting the whole line and hiding colon.
        -- See https://github.com/echasnovski/mini.nvim/discussions/783
        MiniHipatternsFixmeBody        = { fg = c.error },
        MiniHipatternsHackBody         = { fg = c.keyword },
        MiniHipatternsNoteBody         = { fg = c.regexp },
        MiniHipatternsTodoBody         = { fg = c.tag },
        MiniHipatternsFixmeColon       = { bg = c.error,   fg = c.error,   bold = true },
        MiniHipatternsHackColon        = { bg = c.keyword, fg = c.keyword, bold = true },
        MiniHipatternsNoteColon        = { bg = c.regexp,  fg = c.regexp,  bold = true },
        MiniHipatternsTodoColon        = { bg = c.tag,     fg = c.tag,     bold = true },

        -- Bold matches and current line in MiniPick
        MiniPickMatchCurrent           = { fg = nil,      bg = c.selection_bg,  bold = true },
        MiniPickMatchMarked            = { fg = nil,      bg = c.gutter_normal, bold = true },
        MiniPickMatchRanges            = { fg = c.regexp, bold = true },
        MiniPickPrompt                 = { fg = c.regexp, bold = true },
        MiniPickPromptPrefix           = { fg = c.tag,    bold = true },

        -- Dim inactive MiniStarter elements
        MiniStarterInactive            = { link = "MiniJump2dDim" },
        MiniStarterSection             = { fg = c.keyword, bold = true },
        MiniStarterHeader              = { fg = c.tag,     bold = true },

        -- Highlight patterns for deemphasizing the directory name, so the
        -- filename is more prominent. Visually, this makes it faster to
        -- identify the name of the file.
        -- See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
        MiniStatuslineDirectory        = { fg = c.lsp_inlay_hint, bg = c.selection_inactive},
        MiniStatuslineFilename         = { fg = c.fg,             bg = c.selection_inactive,  bold = true },
        MiniStatuslineFilenameModified = { fg = c.fg,             bg = c.selection_inactive,  bold = true },
        MiniStatuslineDevinfo          = { fg = c.fg,             bg = c.selection_bg },
        MiniStatuslineFileinfo         = { fg = c.fg,             bg = c.selection_bg },
        StatusLine                     = { fg = c.fg,             bg = c.panel_border },
        StatusLineNC                   = { fg = c.fg,             bg = c.panel_border },

        RenderMarkdownCode             = { bg = c.selection_inactive },
        RenderMarkdownCodeBorder       = { bg = c.selection_bg },
        RenderMarkdownCodeInline       = { fg = c.tag, bg = c.selection_inactive },
        RenderMarkdownTableHead        = { fg = c.selection_bg },
        RenderMarkdownTableRow         = { fg = c.selection_bg },

        -- Extend the context highlighting to line numbers as well
        TreesitterContext              = { bg = c.selection_inactive },
        TreesitterContextBottom        = { sp = c.panel_bg,     underline = true },
        TreesitterContextLineNumber    = { fg = c.guide_active, bg = c.selection_inactive },

        ['@markup.heading']            = { fg = c.keyword,  bold = true },
        ['@markup.heading.1']          = { fg = c.accent,   bold = true },
        ['@markup.heading.2']          = { fg = c.keyword,  bold = true },
        ['@markup.heading.3']          = { fg = c.markup,   bold = true },
        ['@markup.heading.4']          = { fg = c.entity,   bold = true },
        ['@markup.heading.5']          = { fg = c.regexp,   bold = true },
        ['@markup.heading.6']          = { fg = c.string,   bold = true },
        ['@markup.strong']             = { fg = c.keyword,  bold = true },
        ['@markup.italic']             = { fg = c.keyword,  italic = true },
        ['@markup.quote']              = { fg = c.constant, italic = true },
        ['@markup.raw']                = { fg = c.tag,      bg = c.selection_inactive },
        ['@markup.list']               = { fg = c.vcs_added },
        ['@markup.raw.block']          = { fg = c.tag },
        ['@module']                    = { fg = c.fg },
        ['@string.documentation']      = { fg = c.lsp_inlay_hint },
        ['@variable.builtin']          = { fg = c.fg },
      }
    end,
  })
  vim.cmd.colorscheme("ayu")
end)
