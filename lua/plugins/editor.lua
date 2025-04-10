return {
  {
    "folke/which-key.nvim",
    dev = false,
    opts = {
      preset = "helix",
      icons = {
        -- The helix prefix looks better with this vertical separator. See:
        -- https://github.com/folke/which-key.nvim/discussions/922 as this
        -- requires changing which-key code (I forked it).
        separator = "│",
      },
      spec = {
        { "gx" }, -- unbind for mini.operators exchange mapping
      },
    },
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "ggandor/leap.nvim",
    keys = {
      {
        "s",
        function()
          require("leap").leap({
            target_windows = { vim.api.nvim_get_current_win() },
          })
        end,
        mode = { "x", "n", "o" },
        desc = "Leap current window",
      },
      {
        "S",
        function()
          require("leap").leap({
            target_windows = require("leap.util").get_enterable_windows(),
          })
        end,
        mode = { "n" },
        desc = "Leap other window",
      },
      {
        "gS",
        function()
          require("leap.treesitter").select()
        end,
        mode = { "x", "n", "o" },
        desc = "Leap treesitter",
      },
      {
        "gR",
        function()
          require("leap.remote").action()
        end,
        mode = { "n", "x", "o" },
        desc = "Leap remote",
      },
    },
    config = function(_, opts)
      require("leap.user").set_repeat_keys("<enter>", "<backspace>")
      require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
      return opts
    end,
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-s>"] = false,
      },
    },
  },
}
