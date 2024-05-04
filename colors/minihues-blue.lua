local hues = require("mini.hues")
local opts = {
  background = "#011A33",
  foreground = "#c0c8cb",
  accent = "azure",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-blue"
