return {
  {
    -- I find myself fighting too much with mini.pairs,
    -- and it doesn't work well with python or markdown
    -- triple quotes. nvim-autopairs is simply better.
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "snacks_picker_input" },
    },
  },
  {
    "echasnovski/mini.align",
    keys = {
      { "ga", mode = { "n", "v" }, desc = "Align" },
      { "gA", mode = { "n", "v" }, desc = "Align with preview" },
    },
    opts = {},
  },
  {
    "echasnovski/mini.keymap",
    opts = {},
    config = function()
      local map_combo = require("mini.keymap").map_combo
      map_combo("i", "kk", "<BS><BS><Esc>[sz=gi<Right>")

      local map_multistep = require("mini.keymap").map_multistep
      map_multistep("i", "<Tab>", { "jump_after_tsnode", "jump_after_close" })
      map_multistep("i", "<S-Tab>", { "jump_before_tsnode", "jump_before_open" })
      map_multistep("i", "<CR>", { "nvimautopairs_cr" })
      map_multistep("i", "<BS>", { "nvimautopairs_bs" })
    end,
  },
  {
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "v" }, desc = "Evaluate" },
      { "gx", mode = { "n", "v" }, desc = "Exchange" },
      { "gm", mode = { "n", "v" }, desc = "Multiply" },
      { "gr", mode = { "n", "v" }, desc = "Replace with register" },
      { "g|", mode = { "n", "v" }, desc = "Sort" },
    },
    opts = {
      sort = {
        prefix = "g|",
      },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    keys = {
      { "gJ", mode = { "n", "v" }, desc = "Split/Join" },
    },
    opts = {
      mappings = {
        toggle = "gJ",
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
      },
    },
  },
}
