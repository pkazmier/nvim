require("render-markdown").setup({
  render_modes = { "n", "c", "i" },
  bullets = { "➤" },
  headings = { "◉ ", "○ ", "✸ ", "✿ " },
  highlights = {
    heading = {
      backgrounds = { "CursorLine" },
    },
    bullet = "@markup.list",
    code = "KazCodeBlock",
  },
})
