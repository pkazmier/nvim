require("markview").setup({
  modes = { "n", "no", "i", "c" },
  hybrid_modes = { "i" },
  highlight_groups = {
    {
      group_name = "red",
      value = { bg = "#453244", fg = "#f38ba8" },
    },
    {
      group_name = "red_fg",
      value = { fg = "#f38ba8" },
    },
    {
      group_name = "orange",
      value = { bg = "#46393E", fg = "#fab387" },
    },
    {
      group_name = "orange_fg",
      value = { fg = "#fab387" },
    },
    {
      group_name = "yellow",
      value = { bg = "#464245", fg = "#f9e2af" },
    },
    {
      group_name = "yellow_fg",
      value = { fg = "#f9e2af" },
    },

    {
      group_name = "green",
      value = { bg = "#374243", fg = "#a6e3a1" },
    },
    {
      group_name = "green_fg",
      value = { fg = "#a6e3a1" },
    },
    {
      group_name = "blue",
      value = { bg = "#2E3D51", fg = "#74c7ec" },
    },
    {
      group_name = "blue_fg",
      value = { fg = "#74c7ec" },
    },
    {
      group_name = "mauve",
      value = { bg = "#393B54", fg = "#cba6f7" },
    },
    {
      type = "normal",
      group_name = "mauve_fg",
      value = { fg = "#cba6f7" },
    },
    {
      group_name = "grey",
      value = { bg = "#7E839A", fg = "#313244" },
    },
    {
      group_name = "grey_fg",
      value = { fg = "#7E839A" },
    },
    {
      group_name = "dark",
      value = { link = "KazCodeBlock" },
    },
    {
      group_name = "dark_2",
      value = { bg = "#303030", fg = "#B4BEFE" },
    },
    {
      group_name = "gradient_0",
      value = { fg = "#6583b6" },
    },
    {
      group_name = "gradient_1",
      value = { fg = "#637dac" },
    },
    {
      group_name = "gradient_2",
      value = { fg = "#6177a2" },
    },
    {
      group_name = "gradient_3",
      value = { fg = "#5f7198" },
    },
    {
      group_name = "gradient_4",
      value = { fg = "#5d6c8e" },
    },
    {
      group_name = "gradient_5",
      value = { fg = "#5b6684" },
    },
    {
      group_name = "gradient_6",
      value = { fg = "#59607a" },
    },
    {
      group_name = "decorated_h1",
      value = { bg = "#a6e3a1", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h1_inv",
      value = { fg = "#a6e3a1", bold = true },
    },
    {
      group_name = "decorated_h2",
      value = { bg = "#74c7ec", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h2_inv",
      value = { fg = "#74c7ec", bold = true },
    },
    {
      group_name = "decorated_h3",
      value = { bg = "#cba6f7", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h3_inv",
      value = { fg = "#cba6f7", bold = true },
    },
    {
      group_name = "decorated_h4",
      value = { bg = "#fab387", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h4_inv",
      value = { fg = "#fab387", bold = true },
    },
    {
      group_name = "decorated_h5",
      value = { bg = "#f38ba8", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h5_inv",
      value = { fg = "#f38ba8", bold = true },
    },
    {
      group_name = "decorated_h6",
      value = { bg = "#f9e2af", fg = "#313244", bold = true },
    },
    {
      group_name = "decorated_h6_inv",
      value = { fg = "#f9e2af", bold = true },
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
