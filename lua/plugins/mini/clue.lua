-- stylua: ignore start
local clue = require("mini.clue")
clue.setup({
  window = {
    delay = 300,
    config = { width = "auto", border = "single" },
  },
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- `[]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- `\` key
    { mode = "n", keys = [[\]] },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    { mode = "n", keys = "gz", desc = "Surround" },

    -- Enhance this by adding descriptions for <Leader> mapping groups
    { mode = "n", keys = "<leader>b",  desc = "Buffers" },
    { mode = "n", keys = "<leader>c",  desc = "Code" },
    { mode = "n", keys = "<leader>f",  desc = "Files" },
    { mode = "n", keys = "<leader>g",  desc = "Git/diff" },
    { mode = "n", keys = "<leader>gf", desc = "Find files" },
    { mode = "n", keys = "<leader>m",  desc = "Map" },
    { mode = "n", keys = "<leader>M",  desc = "Mini" },
    { mode = "n", keys = "<leader>n",  desc = "Zk notes" },
    { mode = "n", keys = "<leader>s",  desc = "Search" },
    { mode = "n", keys = "<leader>x",  desc = "Quickfix" },
    { mode = "n", keys = "<leader>q",  desc = "Quit/session" },

    -- Bracketed.
    { mode = "n", keys = "]b", postkeys = "]" },
    { mode = "n", keys = "[b", postkeys = "[" },
    { mode = "n", keys = "]c", postkeys = "]" },
    { mode = "n", keys = "[c", postkeys = "[" },
    { mode = "n", keys = "]d", postkeys = "]" },
    { mode = "n", keys = "[d", postkeys = "[" },
    -- { mode = "n", keys = "]f", postkeys = "]" },
    -- { mode = "n", keys = "[f", postkeys = "[" },
    { mode = "n", keys = "]h", postkeys = "]" },
    { mode = "n", keys = "[h", postkeys = "[" },
    -- { mode = "n", keys = "]i", postkeys = "]" },
    -- { mode = "n", keys = "[i", postkeys = "[" },
    -- { mode = "n", keys = "]j", postkeys = "]" },
    -- { mode = "n", keys = "[j", postkeys = "[" },
    -- { mode = "n", keys = "]l", postkeys = "]" },
    -- { mode = "n", keys = "[l", postkeys = "[" },
    -- { mode = "n", keys = "]o", postkeys = "]" },
    -- { mode = "n", keys = "[o", postkeys = "[" },
    { mode = "n", keys = "]q", postkeys = "]" },
    { mode = "n", keys = "[q", postkeys = "[" },
    { mode = "n", keys = "]t", postkeys = "]" },
    { mode = "n", keys = "[t", postkeys = "[" },
    { mode = "n", keys = "]u", postkeys = "]" },
    { mode = "n", keys = "[u", postkeys = "[" },
    { mode = "n", keys = "]w", postkeys = "]" },
    { mode = "n", keys = "[w", postkeys = "[" },
    -- { mode = "n", keys = "]x", postkeys = "]" },
    -- { mode = "n", keys = "[x", postkeys = "[" },
    { mode = "n", keys = "]y", postkeys = "]" },
    { mode = "n", keys = "[y", postkeys = "[" },

    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows({ submode_resize = true }),
    clue.gen_clues.z(),
  },
})
-- stylua: ignore end
