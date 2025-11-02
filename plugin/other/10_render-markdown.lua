-- ---------------------------------------------------------------------------
-- render-markdown
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, { load = true })
  require("render-markdown").setup({
    file_types = { "markdown", "md", "codecompanion" },
    render_modes = { "n", "no", "c", "t", "i", "ic" },
    code = {
      sign = false,
      border = "thin",
      position = "right",
      width = "block",
      above = "▁",
      below = "▔",
      language_left = "█",
      language_right = "█",
      language_border = "▁",
      left_pad = 1,
      right_pad = 1,
    },
    heading = {
      width = "block",
      backgrounds = {
        "MiniStatusLineModeVisual",
        "MiniStatusLineModeCommand",
        "MiniStatusLineModeReplace",
        "MiniStatusLineModeNormal",
        "MiniStatusLineModeOther",
        "MiniStatusLineModeInsert",
      },
      left_pad = 1,
      right_pad = 0,
      position = "right",
      icons = {
        "",
        "",
        "",
        "",
        "",
        "",
      },
    },
  })
end)
