-- ---------------------------------------------------------------------------
-- rose pine colorscheme
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ { src = "https://github.com/rose-pine/neovim", name = "rose-pine" } }, { load = true })
  require("rose-pine").setup({
    enable = {
      legacy_highlights = false,
    },
    groups = {
      h1 = "love",
      h2 = "iris",
      h4 = "foam",
      h3 = "pine",
      h5 = "rose",
      h6 = "gold",
    },
    -- stylua: ignore
    highlight_groups = {
      Comment                        = { fg = "muted",          italic = true },
      LineNr                         = { fg = "highlight_med" },
      MiniFilesCursorLine            = { bg = "overlay",        bold = true },
      MiniFilesDirectory             = { fg = "foam",           bold = false },
      MiniFilesTitleFocused          = { fg = "gold",           bold = true },
      MiniHipatternsFixmeBody        = { fg = "love" },
      MiniHipatternsHackBody         = { fg = "gold" },
      MiniHipatternsNoteBody         = { fg = "foam" },
      MiniHipatternsTodoBody         = { fg = "iris" },
      MiniHipatternsFixmeColon       = { bg = "love",           fg = "love", bold = true },
      MiniHipatternsHackColon        = { bg = "gold",           fg = "gold", bold = true },
      MiniHipatternsNoteColon        = { bg = "foam",           fg = "foam", bold = true },
      MiniHipatternsTodoColon        = { bg = "iris",           fg = "iris", bold = true },
      MiniMapNormal                  = { fg = "subtle" },
      MiniPickBorderText             = { fg = "foam",           bold = true },
      MiniPickMatchCurrent           = { bg = "overlay",        bold = true },
      MiniPickMatchMarked            = { bg = "highlight_high", blend = 100 },
      MiniPickMatchRanges            = { fg = "foam",           bold = true },
      MiniPickPromptPrefix           = { fg = "iris",           bold = true },
      MiniStarterInactive            = { fg = "muted",          italic = false },
      MiniStarterSection             = { fg = "rose",           bold = true },
      MiniStatuslineDirectory        = { fg = "muted" },
      MiniStatuslineFilename         = { fg = "subtle",         bold = true },
      MiniStatuslineFilenameModified = { fg = "rose",           bold = true },
      MiniStatuslineInactive         = { fg = "subtle",         bold = false },
      RenderMarkdownBullet           = { fg = "pine" },
      RenderMarkdownChecked          = { fg = "iris" },
      RenderMarkdownCodeBorder       = { fg = "iris",           bg = "highlight_med" },
      RenderMarkdownCodeInline       = { fg = "iris",           bg = "overlay" },
      RenderMarkdownTodo             = { fg = "pine" },
      RenderMarkdownUnchecked        = { fg = "pine" },
      TreesitterContextLineNumber    = { fg = "muted" },
      WinSeparator                   = { fg = "overlay" },
      ["@function.method.call"]      = { fg = "rose" },
      ["@lsp.type.formatSpecifier"]  = { link = "@markup.list" },
      ["@lsp.type.namespace.python"] = { fg = "love" },
      ["@lsp.type.parameter"]        = { link = "@variable.parameter" },
      ["@variable.member.go"]        = { fg = "iris" },
      ['@markup.italic']             = { fg = "rose",           italic = true },
      ['@markup.strong']             = { fg = "rose",           bold = true },
    },
    palette = {
      main = {
        -- I think rose-pine's default pine color is simply too dark, so I use
        -- rose-pine's moon variant of pine.
        pine = "#3e8fb0",
      },
    },
    styles = {
      italic = false,
    },
  })
  vim.cmd.colorscheme("rose-pine")
end)
