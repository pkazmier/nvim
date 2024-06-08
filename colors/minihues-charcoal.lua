local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#181A1F",
  foreground = "#A9B2C3",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-charcoal"
