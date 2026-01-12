-- ---------------------------------------------------------------------------
-- oasis colorscheme
-- ---------------------------------------------------------------------------

Config.now(function()
  vim.pack.add({ { src = "https://github.com/uhs-robert/oasis.nvim" } }, { load = true })
  require("oasis").setup({
    highlight_overrides = function(c, colors)
      -- stylua: ignore
      return {
        MiniStatuslineDirectory        = { fg = c.theme.light_primary, bg = c.bg.mantle },
        MiniStatuslineFilename         = { fg = c.theme.light_primary, bg = c.bg.mantle, bold = true },
        MiniStatuslineFilenameModified = { fg = c.theme.light_primary, bg = c.bg.mantle, bold = true },

        RenderMarkdownBullet           = "Special",
        RenderMarkdownChecked          = "String",
        RenderMarkdownTodo             = { fg = c.terminal.cyan },
        RenderMarkdownUnchecked        = { fg = c.terminal.bright_red },
        RenderMarkdownCode             = { bg = c.bg.mantle },
        RenderMarkdownCodeInline       = { bg = c.bg.mantle },
        RenderMarkdownCodeBorder       = { bg = c.bg.surface },
        RenderMarkdownLink             = { fg = c.theme.strong_primary },
        RenderMarkdownWikiLink         = {},
        RenderMarkdownTableHead        = { fg = c.fg.muted },
        RenderMarkdownTableRow         = { fg = c.fg.muted },

        ["@markup.heading.1"]          = { fg = c.terminal.red,            bold = true },
        ["@markup.heading.2"]          = { fg = c.terminal.bright_yellow,  bold = true },
        ["@markup.heading.3"]          = { fg = c.terminal.yellow,         bold = true },
        ["@markup.heading.4"]          = { fg = c.terminal.green,          bold = true },
        ["@markup.heading.5"]          = { fg = c.terminal.bright_magenta, bold = true },
        ["@markup.heading.6"]          = { fg = c.terminal.blue,           bold = true },
        ["@markup.italic"]             = { fg = c.theme.accent,            italic = true },
        ["@markup.link.label"]         = { fg = c.theme.primary },
        ["@string.special.url"]        = { fg = c.theme.secondary },
        ["@markup.strong"]             = { fg = c.theme.accent,            bold = true },
      }
    end,
  })
  vim.cmd.colorscheme("oasis")
end)
