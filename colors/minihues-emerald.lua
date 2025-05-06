local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#0f2728",
  foreground = "#c0c9c9",
}
hues.setup(opts)
local p = hues.make_palette(opts)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-emerald"
