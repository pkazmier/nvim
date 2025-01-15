return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      -- win = {
      --   border = { "─", "─", "─", " ", " ", " ", " ", " " },
      --   title_pos = "left",
      -- },
      icons = {
        -- Helix looks better with this vertical separator. See:
        -- https://github.com/folke/which-key.nvim/discussions/922
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
}
