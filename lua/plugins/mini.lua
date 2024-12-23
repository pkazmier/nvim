return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "gx" },
      },
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
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "v" }, desc = "Evaluate" },
      { "gx", mode = { "n", "v" }, desc = "Exchange" },
      { "gm", mode = { "n", "v" }, desc = "Multiply" },
      { "gr", mode = { "n", "v" }, desc = "Replace with register" },
      { "gS", mode = { "n", "v" }, desc = "Sort" },
    },
    opts = {
      sort = {
        prefix = "gS",
      },
    },
  },
  {
    -- I find myself fighting too much with mini.pairs,
    -- and it doesn't work well with python or markdown
    -- triple quotes. nvim-autopairs is simply better.
    "echasnovski/mini.pairs",
    enabled = false,
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
}
