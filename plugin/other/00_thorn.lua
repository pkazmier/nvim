-- ---------------------------------------------------------------------------
-- thorn colorscheme
-- ---------------------------------------------------------------------------

Config.now(function()
  vim.pack.add({ { src = "https://github.com/jpwol/thorn.nvim" } })
  require("thorn").setup({
    on_highlights = function(hl, p)
      hl.LeapLabel = { fg = p.bg, bg = p.orange, bold = true }
      hl.MiniStatuslineDirectory = { bg = p.statusbar.bg, fg = p.fg }
      hl.MiniStatuslineFilename = { bg = p.statusbar.bg, fg = p.fg, bold = true }
      hl.RenderMarkdownTableHead = { fg = p.green_5 }
      hl.RenderMarkdownTableRow = { fg = p.green_5 }
      hl["@markup.strong"] = { fg = p.green_2, bold = true }
      hl["@markup.italic"] = { fg = p.green_2, italic = true }
    end,
  })
  vim.cmd.colorscheme("thorn")
end)
