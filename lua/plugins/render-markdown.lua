require("render-markdown").setup({
  render_modes = { "n", "c", "i" },
  bullets = { "➤" },
  headings = { "◉ ", "○ ", "✸ ", "✿ " },
  highlights = {
    heading = {
      backgrounds = { "CursorLine" },
    },
    code = "Ignore",
  },
})
