require("markview").setup({
  modes = { "n", "i" },
  highlight_groups = {
    {
      group_name = "dark",
      value = { link = "KazCodeBlock" },
    },
    {
      group_name = "decorated_h1",
      value = { bg = "#f38ba8", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h1_inv",
      value = { fg = "#f38ba8", bold = true },
    },
    {
      group_name = "decorated_h2",
      value = { bg = "#fab387", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h2_inv",
      value = { fg = "#fab387", bold = true },
    },
    {
      group_name = "decorated_h3",
      value = { bg = "#f9e2af", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h3_inv",
      value = { fg = "#f9e2af", bold = true },
    },
    {
      group_name = "decorated_h4",
      value = { bg = "#a6e3a1", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h4_inv",
      value = { fg = "#a6e3a1", bold = true },
    },
    {
      group_name = "decorated_h5",
      value = { bg = "#74c7ec", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h5_inv",
      value = { fg = "#74c7ec", bold = true },
    },
    {
      group_name = "decorated_h6",
      value = { bg = "#b4befe", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h6_inv",
      value = { fg = "#b4befe", bold = true },
    },
  },
  code_blocks = {
    enable = true,

    style = "language",
    hl = "dark",

    position = "overlay",

    min_width = 60,
    pad_amount = 3,

    language_names = {
      { "py", "python" },
      { "cpp", "C++" },
    },
    language_direction = "right",

    sign = false,
    sign_hl = nil,
  },
  headings = {
    shift_width = 0,

    heading_1 = {
      style = "label",

      padding_left = " ",
      padding_right = " ",

      corner_right = "",
      corner_right_hl = "decorated_h1_inv",

      icon = "󰼏  ",
      sign = "",
      hl = "decorated_h1",
    },
    heading_2 = {
      style = "label",

      padding_left = " ",
      padding_right = " ",

      corner_right = "",
      corner_right_hl = "decorated_h2_inv",

      icon = "󰎨  ",
      sign = "",
      hl = "decorated_h2",
    },
    heading_3 = {
      style = "label",

      padding_left = " ",
      padding_right = " ",

      corner_right = "",
      corner_right_hl = "decorated_h3_inv",

      icon = "󰼑  ",
      hl = "decorated_h3",
      sign = "",
    },
    heading_4 = {
      style = "label",

      padding_left = " ",
      padding_right = " ",

      corner_right = "",
      corner_right_hl = "decorated_h4_inv",

      icon = "󰎲  ",
      sign = "",
      hl = "decorated_h4",
    },
    heading_5 = {
      style = "label",

      padding_left = " ",
      padding_right = " ",

      corner_right = "",
      corner_right_hl = "decorated_h5_inv",

      icon = "󰼓  ",
      sign = "",
      hl = "decorated_h5",
    },
    heading_6 = {
      style = "label",

      padding_left = " ",
      padding_right = " ",

      corner_right = "",
      corner_right_hl = "decorated_h6_inv",

      icon = "󰎴  ",
      sign = "",
      hl = "decorated_h6",
    },
  },
})
