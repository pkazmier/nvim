local hues = require("mini.hues")
math.randomseed(vim.loop.hrtime())
local base_colors = hues.gen_random_base_colors()
local p = hues.get_palette()
  background = base_colors.background,
  foreground = base_colors.foreground,
  saturation = vim.o.background == "dark" and "medium" or "high",
  accent = "azure",
})
hues.apply_palette(p)
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-myrandomhue"
