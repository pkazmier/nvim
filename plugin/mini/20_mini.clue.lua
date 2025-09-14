MiniDeps.later(function()
  local clue = require("mini.clue")

  clue.setup({
    clues = {
      assert(Config.leader_group_clues, "mappings must be loaded first"),
      assert(Config.mini_diff_clues, "mini.diff must be loaded first"),
      assert(Config.mini_bracketed_clues, "mini.bracketed must be loaded first"),
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers({ show_contents = true }),
      clue.gen_clues.windows({ submode_resize = true }),
      clue.gen_clues.z(),
    },
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = [[\]] }, -- mini.basics
      { mode = "n", keys = "[" }, -- mini.bracketed
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
      { mode = "i", keys = "<C-x>" }, -- built-in completion
      { mode = "n", keys = "g" }, -- `g` key
      { mode = "x", keys = "g" },
      { mode = "n", keys = "'" }, -- marks
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = '"' }, -- registers
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "s" }, -- surround
      { mode = "n", keys = "<C-w>" }, -- windows
      { mode = "n", keys = "z" }, -- folds
      { mode = "x", keys = "z" },
    },
    window = {
      delay = 300,
      config = { width = "auto" },
    },
  })
end)
