MiniDeps.now(function()
  vim.pack.add({ "https://github.com/Shatur/neovim-ayu" }, { load = true })
  require("ayu").setup({
    mirage = true,
    terminal = true,
    overrides = function()
      local c = require("ayu.colors")
      -- stylua: ignore
      return {
        -- TODO: open PR to fix MiniMap background
        -- MiniMapNormal = { bg = c.panel_bg },
        NormalFloat                    = { bg = c.panel_bg },

        MiniFilesCursorLine = { fg = nil, bg = c.line, bold = true },

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

        MiniMapNormal                  = { fg = c.lsp_inlay_hint, bg = c.panel_bg },

        -- Bold matches in MiniPick
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

        RenderMarkdownCodeBorder       = { bg = c.panel_border },

        TreesitterContextLineNumber    = { fg = c.comment, bg = c.selection_inactive },
        TreesitterContextBottom        = { sp = c.selection_bg, underdotted = true },

        ['@markup.italic']             = { fg = c.string, italic = true },
        ['@markup.strong']             = { fg = c.string, bold = true },
        ['@module']                    = { fg = c.fg },
        ['@string.documentation']      = { fg = c.lsp_inlay_hint },
        ['@variable.builtin']          = { fg = c.fg },
      }
    end,
  })
  vim.cmd.colorscheme("ayu")
end)
