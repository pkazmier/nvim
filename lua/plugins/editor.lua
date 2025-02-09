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
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader>fp",
        LazyVim.pick("files", { cwd = require("lazy.core.config").options.root }),
        desc = "Find Plugin File",
      },
    },
    opts = function(_, opts)
      if vim.g.kaz_transparency then
        opts.fzf_colors = {
          true,
          bg = "-1",
          gutter = "-1",
        }
      end
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
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-s>"] = false,
      },
    },
  },
}
