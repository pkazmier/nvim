local hues = require("mini.hues")
-- stylua: ignore
local p = {
  bg_edge2  = "#0c0705",
  bg_edge   = "#1b1512",
  bg        = "#27211e",
  bg_mid    = "#433c39",
  bg_mid2   = "#605855",
  fg_edge2  = "#eef1f8",
  fg_edge   = "#e0e2e9",
  fg        = "#d2d4db",
  fg_mid    = "#b2b4bb",
  fg_mid2   = "#93949b",

  accent    = "#f6cc9b",
  accent_bg = "#492c00",

  red       = "#fac0e4",
  red_bg    = "#3a0f2e",
  orange    = "#ffc1b9",
  orange_bg = "#410d0c",
  yellow    = "#f6cc9b",
  yellow_bg = "#492c00",
  green     = "#d1db9f",
  green_bg  = "#313600",
  cyan      = "#a6e5c3",
  cyan_bg   = "#003d26",
  azure     = "#93e4ee",
  azure_bg  = "#004a51",
  blue      = "#acd6ff",
  blue_bg   = "#002649",
  purple    = "#d8caff",
  purple_bg = "#271844",
}
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-summer"
