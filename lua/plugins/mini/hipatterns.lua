local hipatterns = require("mini.hipatterns")

require("mini.hipatterns").setup({
  highlighters = {
    -- Hex colors
    hex_color = hipatterns.gen_highlighter.hex_color(),

    -- Conventional Commit breaking change
    breaking = { pattern = "%w+%(?%w*%)?!:", group = "MiniHipatternsFixme" },

    -- TODO/FIXME/HACK/NOTE
    fixme = { pattern = "() FIXME():", group = "MiniHipatternsFixme" },
    hack = { pattern = "() HACK():", group = "MiniHipatternsHack" },
    todo = { pattern = "() TODO():", group = "MiniHipatternsTodo" },
    note = { pattern = "() NOTE():", group = "MiniHipatternsNote" },
    fixme_colon = { pattern = " FIXME():()", group = "MiniHipatternsFixmeColon" },
    hack_colon = { pattern = " HACK():()", group = "MiniHipatternsHackColon" },
    todo_colon = { pattern = " TODO():()", group = "MiniHipatternsTodoColon" },
    note_colon = { pattern = " NOTE():()", group = "MiniHipatternsNoteColon" },
    fixme_body = { pattern = " FIXME:().*()", group = "MiniHipatternsFixmeBody" },
    hack_body = { pattern = " HACK:().*()", group = "MiniHipatternsHackBody" },
    todo_body = { pattern = " TODO:().*()", group = "MiniHipatternsTodoBody" },
    note_body = { pattern = " NOTE:().*()", group = "MiniHipatternsNoteBody" },
  },
})
