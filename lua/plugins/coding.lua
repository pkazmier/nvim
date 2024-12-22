return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "dhruvmanila/browser-bookmarks.nvim",
    keys = {
      { "<leader>sB", "<cmd>BrowserBookmarks<cr>", desc = "Safari Bookmarks" },
    },
    opts = {
      selected_browser = "safari",
    },
  },
}
