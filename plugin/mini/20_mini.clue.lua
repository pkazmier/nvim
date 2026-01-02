-- ---------------------------------------------------------------------------
-- mini.clue
-- ---------------------------------------------------------------------------

Config.later(function()
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
      { mode = "n", keys = [[\]] }, -- mini.basics
      { mode = "i", keys = "<C-x>" }, -- built-in completion
      { mode = "n", keys = "s" }, -- surround
      { mode = "n", keys = "<C-w>" }, -- windows
      { mode = { "n", "x" }, keys = "<Leader>" },
      { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
      { mode = { "n", "x" }, keys = "]" },
      { mode = { "n", "x" }, keys = "g" }, -- `g` key
      { mode = { "n", "x" }, keys = "'" }, -- marks
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' }, -- registers
      { mode = { "n", "x" }, keys = "z" }, -- folds
      { mode = { "i", "c" }, keys = "<C-r>" },
    },
    window = {
      config = { width = "auto" },
    },
  })
end)
