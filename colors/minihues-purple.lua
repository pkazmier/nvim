local hues = require("mini.hues")
local opts = {
  accent = "purple",
  background = "#151025",
  foreground = "#B6BCBF",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-purple"
