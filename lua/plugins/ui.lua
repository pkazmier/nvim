return {
  { "akinsho/bufferline.nvim", opts = { options = { separator_style = "slope" } } },
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts.lualine_bold = true
      return opts
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "╲", right = "╱" }
      return opts
    end,
  },
}
