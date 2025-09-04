local hues = require("mini.hues")
local opts = {
  background = "#12252e",
  foreground = "#c0c8cc",
  accent = "azure",
}
hues.setup(opts)
local p = hues.get_palette()
Config.minihues_apply_custom_highlights(p)
vim.g.colors_name = "minihues-teal"
