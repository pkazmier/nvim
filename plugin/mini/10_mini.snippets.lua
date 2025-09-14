MiniDeps.later(function()
  local snippets = require("mini.snippets")
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file("~/.config/minivim/snippets/global.json"),
      snippets.gen_loader.from_file("~/.config/minivim/snippets/mini-test.json"),
      snippets.gen_loader.from_lang(),
    },
  })
end)
