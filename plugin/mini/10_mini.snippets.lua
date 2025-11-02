-- ---------------------------------------------------------------------------
-- mini.snippets
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  local snippets = require("mini.snippets")
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file("~/.config/minivim/snippets/global.json"),
      snippets.gen_loader.from_file("~/.config/minivim/snippets/mini-test.json"),
      snippets.gen_loader.from_lang({
        lang_patterns = {
          markdown_inline = { "markdown.json" },
        },
      }),
    },
  })
end)
