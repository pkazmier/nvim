-- ---------------------------------------------------------------------------
-- boo-berry colorscheme
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ { src = "https://github.com/booberrytheme/boo-berry.nvim" } })
  require("boo-berry").setup({
    overrides = function(c)
      return {
        DiagnosticError = { fg = c.pink },
        DiagnosticWarn = { fg = c.yellow },
        DiagnosticOk = { fg = c.green },
        DiagnosticInfo = { fg = c.purple },
        DiagnosticHint = { fg = c.purple },

        MiniStatuslineDirectory = { fg = c.comment, bg = c.menu },
        MiniStatuslineFilename = { bg = c.menu, bold = true },
        MiniStatuslineFilenameModified = { bg = c.menu, bold = true },

        MiniTablineModifiedCurrent = { bg = c.red, fg = c.bg, bold = true },
        MiniTablineModifiedVisible = { fg = c.bg, bg = c.fg, bold = true },
        MiniTablineModifiedHidden = { fg = c.bg, bg = c.fg },
        MiniTablineVisible = { bg = c.nontext, bold = true },
        MiniTablineCurrent = { fg = c.red, bg = c.bg, bold = true },

        MiniStarterQuery = { fg = c.green, bold = true },
        MiniStarterItemPrefix = { fg = c.yellow, bold = true },
        MiniStarterSection = { fg = c.red, bold = true },
        MiniStarterFooter = { fg = c.comment },

        RenderMarkdownCode = { bg = c.nontext },
        RenderMarkdownCodeBorder = { bg = c.nontext },
        RenderMarkdownCodeInline = { fg = c.yellow, bg = c.nontext },
        RenderMarkdownTableHead = { fg = c.nontext },
        RenderMarkdownTableRow = { fg = c.nontext },
        RenderMarkdownChecked = { fg = c.green },
        RenderMarkdownUnchecked = { fg = c.yellow },
        RenderMarkdownTodo = { fg = c.yellow },
        RenderMarkdownBullet = { fg = c.yellow },
        RenderMarkdownLink = { fg = c.purple },

        ["@markup.strong"] = { fg = c.red, bold = true },
        ["@markup.italic"] = { fg = c.red, italic = true },
        ["@markup.heading.1"] = { fg = c.purple, bold = true },
        ["@markup.heading.2"] = { fg = c.red, bold = true },
        ["@markup.heading.3"] = { fg = c.yellow, bold = true },
        ["@markup.heading.4"] = { fg = c.green, bold = true },
        ["@markup.heading.5"] = { fg = c.comment, bold = true },
        ["@markup.heading.6"] = { fg = c.comment, bold = true },
      }
    end,
  })
end)
