MiniDeps.now(function()
  vim.pack.add({ "https://github.com/Shatur/neovim-ayu" }, { load = true })
  require("ayu").setup({
    mirage = true,
    terminal = true,
    overrides = function()
      local c = require("ayu.colors")
      -- stylua: ignore
      return {
        CursorLineNr                   = { fg = c.accent, bg = c.line, bold = true },

        -- Use reverse text for diagnostics
        DiagnosticVirtualTextError     = { bg = c.error,   fg = c.line, italic = true },
        DiagnosticVirtualTextWarn      = { bg = c.keyword, fg = c.line, italic = true },
        DiagnosticVirtualTextInfo      = { bg = c.tag,     fg = c.line, italic = true },
        DiagnosticVirtualTextHint      = { bg = c.regexp,  fg = c.line, italic = true },

        -- I prefer dimming background and brighter labels
        LeapBackdrop                   = { link = "MiniJump2dDim" },
        LeapLabel                      = { fg = c.accent, bold = true },

        -- By default ayu uses the same background for floats as the normal
        -- editing window. I prefer a darker background for all floats.
        NormalFloat                    = { bg = c.panel_bg },
        FloatBorder                    = { fg = c.comment, bg = c.panel_bg },

        -- Bold current line in MiniFiles
        MiniFilesCursorLine            = { fg = nil, bg = c.line, bold = true },

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
        MiniPickMatchCurrent           = { fg = nil, bg = c.line, bold = true },
        MiniPickMatchRanges            = { bg = nil, fg = c.regexp, bold = true},

        -- Dim inactive MiniStarter elements
        MiniStarterInactive            = { link = "MiniJump2dDim" },

        -- Highlight patterns for deemphasizing the directory name, so the
        -- filename is more prominent. Visually, this makes it faster to
        -- identify the name of the file.
        -- See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
        MiniStatuslineDirectory        = { fg = c.lsp_inlay_hint, bg = c.panel_border },
        MiniStatuslineFilename         = { fg = c.fg,             bg = c.panel_border, bold = true },
        MiniStatuslineFilenameModified = { fg = c.fg,             bg = c.panel_border, bold = true },
        MiniStatuslineDevinfo          = { fg = c.fg,             bg = c.selection_bg },
        MiniStatuslineFileinfo         = { fg = c.fg,             bg = c.selection_bg },
        StatusLine                     = { fg = c.fg,             bg = c.panel_border },
        StatusLineNC                   = { fg = c.fg,             bg = c.panel_border },

        RenderMarkdownBullet           = { fg = c.vcs_added },
        RenderMarkdownCode             = { bg = c.selection_inactive },
        RenderMarkdownCodeBorder       = { bg = c.selection_bg },
        RenderMarkdownCodeInline       = { fg = c.tag, bg = c.selection_inactive },

        -- Extend the context highlighting to line numbers as well
        TreesitterContextBottom        = { sp = c.selection_bg, underdotted = true },
        TreesitterContextLineNumber    = { fg = c.guide_active, bg = c.selection_inactive },

        ['@markup.heading']            = { fg = c.keyword, bold = true },
        ['@markup.strong']             = { fg = c.keyword, bold = true },
        ['@markup.italic']             = { fg = c.keyword, italic = true },
        ['@markup.list']               = { fg = c.vcs_added },
        ['@markup.raw']                = { fg = c.tag, bg = c.selection_inactive },
        ['@markup.quote']              = { fg = c.constant, italic = true },
        ['@module']                    = { fg = c.fg },
        ['@string.documentation']      = { fg = c.lsp_inlay_hint },
        ['@variable.builtin']          = { fg = c.fg },
      }
    end,
  })
  vim.cmd.colorscheme("ayu")
end)
