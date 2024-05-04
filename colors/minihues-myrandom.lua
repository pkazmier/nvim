local hues = require("mini.hues")
math.randomseed(vim.loop.hrtime())
local base_colors = hues.gen_random_base_colors()
local opts = {
  background = base_colors.background,
  foreground = base_colors.foreground,
  saturation = vim.o.background == "dark" and "medium" or "high",
  accent = "azure",
}
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
vim.g.colors_name = "minihues-myrandomhue"
