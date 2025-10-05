local hues = require("mini.hues")
local opts = {
  accent = "purple",
  background = "#151025",
  foreground = "#B6BCBF",
}
hues.setup(opts)
local p = hues.get_palette()
p.accent_bg = p.bg_edge
hues.apply_palette(p)
vim.g.colors_name = "minihues-darkpurple"
