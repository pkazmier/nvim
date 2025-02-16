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
