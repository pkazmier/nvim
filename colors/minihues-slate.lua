local hues = require("mini.hues")
vim.g.colors_name = "minihues-slate"
local opts = {
  accent = "azure",
  background = "#1a2331",
  foreground = "#c3c7cd",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
