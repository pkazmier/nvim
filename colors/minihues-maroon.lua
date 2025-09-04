local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#2c1d28",
  foreground = "#cbc4c9",
}
hues.setup(opts)
local p = hues.get_palette()
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-maroon"
