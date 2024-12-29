return {
  {
    "dhruvmanila/browser-bookmarks.nvim",
    keys = {
      { "<leader>sB", "<cmd>BrowserBookmarks<cr>", desc = "Safari Bookmarks" },
    },
    opts = {
      selected_browser = "safari",
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      icons = {
        separator = "│",
      },
      spec = {
        { "gx" }, -- unbind for mini.operators exchange mapping
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
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
