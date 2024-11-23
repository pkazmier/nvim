local oil = require("oil")
oil.setup({
  win_options = {
    foldenable = false,
    foldmethod = "manual",
  },
  keymaps = {
    ["h"] = "actions.parent",
    ["l"] = "actions.select",
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-s>"] = false,
  },
})
