-- ---------------------------------------------------------------------------
-- rose pine colorscheme
-- ---------------------------------------------------------------------------

Config.now(function()
  vim.pack.add(
    { { src = "https://github.com/rose-pine/neovim", name = "rose-pine" } },
    { load = true }
  )
  require("rose-pine").setup({
    enable = {
      legacy_highlights = false,
    },
    -- stylua: ignore
    highlight_groups = {
      Comment                        = { fg = "muted",  italic = true },
      MiniHipatternsFixmeBody        = { fg = "love" },
      MiniHipatternsHackBody         = { fg = "gold" },
      MiniHipatternsNoteBody         = { fg = "foam" },
      MiniHipatternsTodoBody         = { fg = "iris" },
      MiniHipatternsFixmeColon       = { bg = "love",   fg = "love", bold = true },
      MiniHipatternsHackColon        = { bg = "gold",   fg = "gold", bold = true },
      MiniHipatternsNoteColon        = { bg = "foam",   fg = "foam", bold = true },
      MiniHipatternsTodoColon        = { bg = "iris",   fg = "iris", bold = true },
      MiniMapNormal                  = { fg = "subtle" },
      MiniPickBorderText             = { fg = "foam",   bold   = true },
      MiniStarterInactive            = { fg = "muted",  italic = false },
      MiniStarterSection             = { fg = "rose",   bold   = true },
      MiniStatuslineDirectory        = { fg = "muted" },
      MiniStatuslineFilename         = { fg = "subtle", bold   = true },
      MiniStatuslineFilename         = { fg = "subtle", bold   = true },
      MiniStatuslineFilenameModified = { fg = "rose",   bold   = true },
      MiniStatuslineInactive         = { fg = "subtle", bold   = false },
      RenderMarkdownCodeInline       = { fg = "iris", bg = "highlight_med" },
      RenderMarkdownCodeBorder       = { fg = "iris", bg = "highlight_med" },
      WinSeparator                   = { fg = "overlay" },
      ["@lsp.type.parameter"]        = { link = "@variable.parameter" },
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
  -- vim.cmd.colorscheme("rose-pine")
end)
