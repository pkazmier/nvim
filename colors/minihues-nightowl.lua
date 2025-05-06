local hues = require("mini.hues")
local opts = {
  background = "#021d33",
  foreground = "#c0c8cb",
  accent = "azure",
}
hues.setup(opts)
local p = hues.make_palette(opts)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-nightowl"
