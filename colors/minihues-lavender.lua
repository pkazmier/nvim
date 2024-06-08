local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#232030",
  foreground = "#c7c6cd",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-lavender"
