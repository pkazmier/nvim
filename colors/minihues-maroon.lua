local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#2c1d28",
  foreground = "#cbc4c9",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-maroon"
