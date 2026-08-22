local hues = require("mini.hues")
local opts = {
  accent = "purple",
  background = "#232030",
  foreground = "#c6c6cd",
}
hues.setup(opts)
local p = hues.get_palette()
p.accent_bg = p.bg_edge
hues.apply_palette(p)
vim.g.colors_name = "minihues-purple"
