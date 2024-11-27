local oil = require("oil")
oil.setup({
  keymaps = {
    ["h"] = "actions.parent",
    ["l"] = "actions.select",
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-s>"] = false,
  },
})
