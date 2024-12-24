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
}
