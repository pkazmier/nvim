local hues = require("mini.hues")
local opts = {
  accent = "purple",
  background = "#151025",
  foreground = "#B6BCBF",
}
hues.setup(opts)
local p = hues.make_palette(opts)
p.accent_bg = p.bg_edge
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-purple"
