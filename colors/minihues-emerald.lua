local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#0f2728",
  foreground = "#c0c9c9",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-emerald"
