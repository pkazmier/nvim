require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
require("leap.user").set_repeat_keys("<enter>", "<backspace>")

vim.keymap.set({ "n", "o" }, "s", function()
  require("leap").leap({
    target_windows = require("leap.user").get_focusable_windows(),
  })
end)

vim.keymap.set({ "o" }, "r", function()
  require("leap.remote").action()
end)

vim.keymap.set({ "n", "x", "o" }, "<C-Space>", function()
  require("leap.treesitter").select()
end)
