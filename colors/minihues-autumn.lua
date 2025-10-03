local hues = require("mini.hues")
-- stylua: ignore
local p = {
  bg_edge2  = "#0b060e",
  bg_edge   = "#1a141d",
  bg        = "#262029",
  bg_mid    = "#423b45",
  bg_mid2   = "#5e5762",
  fg_edge2  = "#f3f1e9",
  fg_edge   = "#e5e3db",
  fg        = "#d7d5cd",
  fg_mid    = "#b7b5ad",
  fg_mid2   = "#97958e",

  accent    = "#e4caf1",
  accent_bg = "#3a0f2f",

  red       = "#f1c6e2",
  red_bg    = "#3a0f2f",
  orange    = "#fac6c1",
  orange_bg = "#410d0d",
  yellow    = "#efcfab",
  yellow_bg = "#492c00",
  green     = "#d3daad",
  green_bg  = "#323700",
  cyan      = "#b4e2c7",
  cyan_bg   = "#003c24",
  azure     = "#a7e1e8",
  azure_bg  = "#004b51",
  blue      = "#b8d9fc",
  blue_bg   = "#00284a",
  purple    = "#d7cef9",
  purple_bg = "#261844",
}
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-autumn"
