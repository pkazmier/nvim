local hues = require("mini.hues")
-- stylua: ignore
local p = {
  bg_edge2  = "#040b02",
  bg_edge   = "#101a0b",
  bg        = "#1c2617",
  bg_mid    = "#374231",
  bg_mid2   = "#535f4d",
  fg_edge2  = "#eef1f7",
  fg_edge   = "#e0e3e9",
  fg        = "#d2d5db",
  fg_mid    = "#b2b5bb",
  fg_mid2   = "#92959b",

  accent    = "#bee2ad",
  accent_bg = "#00381d",

  red       = "#ffc1bf",
  red_bg    = "#410d12",
  orange    = "#facb9e",
  orange_bg = "#492900",
  yellow    = "#d8da9d",
  yellow_bg = "#373700",
  green     = "#abe5be",
  green_bg  = "#00381d",
  cyan      = "#94e5ea",
  cyan_bg   = "#004c4f",
  azure     = "#a9d8ff",
  azure_bg  = "#002d4d",
  blue      = "#d3ccff",
  blue_bg   = "#231946",
  purple    = "#f7c2ea",
  purple_bg = "#381031",
}
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-spring"
