local hues = require("mini.hues")
local opts = {
  accent = "green",
  background = "#18271a",
  foreground = "#c2c9c3",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-olive"
