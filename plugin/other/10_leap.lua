MiniDeps.later(function()
  vim.pack.add({ "https://github.com/ggandor/leap.nvim" }, { load = true })
  require("leap.user").set_repeat_keys("<CR>", "<BS>")
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
end)
