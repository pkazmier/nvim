-- ---------------------------------------------------------------------------
-- tokyonight colorscheme
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
  ---@diagnostic disable-next-line: missing-fields
  require("tokyonight").setup({
    lualine_bold = true,
    on_highlights = function(hl, c)
      hl["LeapLabel"] = { fg = c.blue1, bold = true }
      hl["TreesitterContext"] = { bg = c.bg_dark1 }
      hl["TreesitterContextLineNumber"] = { fg = c.fg_gutter, bg = c.bg_dark1 }
      hl["TreesitterContextBottom"] = { underline = true, sp = c.bg_highlight }

      -- Highlight patterns for deemphasizing the directory name, so the
      -- filename is more prominent. Visually, this makes it faster to
      -- identify the name of the file.
      -- See https://github.com/echasnovski/mini.nvim/discussions/36#discussioncomment-8889147
      hl["MiniStatuslineInactive"] = { fg = c.fg_dark, bg = c.bg_dark }
      hl["MiniStatuslineDirectory"] = { fg = c.fg_dark, bg = c.bg_highlight }
      hl["MiniStatuslineFilename"] = { fg = c.fg, bg = c.bg_highlight, bold = true }
      hl["MiniStatuslineFilenameModified"] = { fg = c.yellow, bg = c.bg_highlight, bold = true }
      hl["RenderMarkdownCodeBorder"] = { bg = c.bg_highlight }
    end,
  })
  -- vim.cmd.colorscheme("tokyonight-moon")
end)
