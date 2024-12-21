return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    render_modes = { "n", "c", "t", "i" },
    anti_conceal = {
      ignore = {
        -- code_border = true,
        code_background = true,
      },
    },
    code = {
      sign = false,
      position = "right",
      left_pad = 1,
      right_pad = 1,
    },
    heading = {
      sign = false,
      border = true,
      -- width = "block",
      below = "▔",
      above = "▁",
      left_pad = 1,
      right_pad = 4,
      icons = { " ", " ", " ", " ", " ", " " },
    },
  },
}
