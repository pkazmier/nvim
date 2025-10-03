local hues = require("mini.hues")
-- stylua: ignore
local p = {
  bg_edge2  = "#000f15",
  bg_edge   = "#051a20",
  bg        = "#11262d",
  bg_mid    = "#2c4249",
  bg_mid2   = "#485f67",
  fg_edge2  = "#f4f0e9",
  fg_edge   = "#e6e2db",
  fg        = "#d8d4cd",
  fg_mid    = "#b8b4ad",
  fg_mid2   = "#98948e",

  accent    = "#b3daf9",
  accent_bg = "#00324f",

  red       = "#fac5c7",
  red_bg    = "#410d14",
  orange    = "#f2ccad",
  orange_bg = "#492600",
  yellow    = "#d9d8aa",
  yellow_bg = "#3a3800",
  green     = "#b8e1c1",
  green_bg  = "#003415",
  cyan      = "#a6e1e2",
  cyan_bg   = "#004c4e",
  azure     = "#b3daf9",
  azure_bg  = "#00324f",
  blue      = "#d1cffb",
  blue_bg   = "#211a46",
  purple    = "#edc7e7",
  purple_bg = "#371134",
}
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-winter"
