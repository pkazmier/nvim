local hues = require("mini.hues")
local opts = {
  accent = "green",
  background = "#18271a",
  foreground = "#c2c9c3",
}
hues.setup(opts)
local p = hues.make_palette(opts)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-olive"
