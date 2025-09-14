MiniDeps.later(function()
  vim.pack.add({ "https://github.com/folke/tokyonight.nvim" }, { load = true })
  ---@diagnostic disable-next-line: missing-fields
  require("tokyonight").setup({
    lualine_bold = true,
    on_highlights = function(hl, c)
      hl["LeapLabel"] = { fg = c.blue1, bold = true }
      hl["TreesitterContext"] = { bg = c.bg_dark1 }
      hl["TreesitterContextLineNumber"] = { fg = c.fg_gutter, bg = c.bg_dark1 }
      hl["TreesitterContextBottom"] = { underline = true, sp = c.bg_highlight }

      -- Highlight patterns for highlighting the whole line and hiding colon.
      -- See https://github.com/echasnovski/mini.nvim/discussions/783
      hl["MiniHipatternsFixme"] = { fg = c.bg, bg = c.red }
      hl["MiniHipatternsFixmeBody"] = { fg = c.red }
      hl["MiniHipatternsFixmeColon"] = { bg = c.red, fg = c.red, bold = true }
      hl["MiniHipatternsHack"] = { fg = c.bg, bg = c.yellow }
      hl["MiniHipatternsHackBody"] = { fg = c.yellow }
      hl["MiniHipatternsHackColon"] = { bg = c.yellow, fg = c.yellow, bold = true }
      hl["MiniHipatternsNote"] = { fg = c.bg, bg = c.cyan }
      hl["MiniHipatternsNoteBody"] = { fg = c.cyan }
      hl["MiniHipatternsNoteColon"] = { bg = c.cyan, fg = c.cyan, bold = true }
      hl["MiniHipatternsTodo"] = { fg = c.bg, bg = c.blue }
      hl["MiniHipatternsTodoBody"] = { fg = c.blue }
      hl["MiniHipatternsTodoColon"] = { bg = c.blue, fg = c.blue, bold = true }

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
