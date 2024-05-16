local hues = require("mini.hues")
local opts = {
  background = "#172331",
  foreground = "#c2c7cd",
  accent = "azure",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-teal"
