local hues = require("mini.hues")
vim.g.colors_name = "minihues-lavender"
local opts = {
  accent = "azure",
  background = "#232030",
  foreground = "#c7c6cd",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
