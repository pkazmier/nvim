require("mini.basics").setup({
  options = {
    -- NOTE: This is disable intentionally.
    -- When enabled, it results in small icons within MiniFiles floating
    -- windows. This has something to do with the winblend (transparency)
    -- setting. So, it's a tradeoff beteween transparency or bigger icons.
    extra_ui = false,
  },
  mappings = {
    windows = true,
    move_with_alt = true,
  },
})
