local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#1a2331",
  foreground = "#c3c7cd",
}
hues.setup(opts)
local p = hues.get_palette()
p.accent_bg = p.bg_edge
hues.apply_palette(p)
vim.g.colors_name = "minihues-slate"
