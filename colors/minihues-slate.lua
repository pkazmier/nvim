local hues = require("mini.hues")
local opts = {
  accent = "azure",
  background = "#1a2331",
  foreground = "#c3c7cd",
}
hues.setup(opts)
local p = hues.make_palette(opts)
p.accent_bg = p.bg_edge
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-slate"
