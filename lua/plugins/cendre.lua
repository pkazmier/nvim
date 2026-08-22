-- ---------------------------------------------------------------------------
-- cendre colorscheme
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

-- stylua: ignore
loader.now(function()
  vim.pack.add({ { src = "https://github.com/Aejkatappaja/cendre" } })
  -- vim.cmd.packadd("cendre-dev")

  local transparent = false

  require("cendre").setup({
    background = "hard",
    transparent = transparent,
    on_highlights = function(hl, c)
      hl.LeapLabel                      = { fg = c.ember, bold = true }
      hl.LeapBackdrop                   = { fg = c.gutter }

      -- I have customized mini.statusline to allow me to style the filename
      -- and directory separately as well as whether or not the filename has
      -- been modified.
      hl.MiniStatuslineDirectory        = { fg = c.fg_dim, bg = c.bg2 }
      hl.MiniStatuslineFilename         = { fg = c.fg_dim, bg = c.bg2, bold = true }
      hl.MiniStatuslineFilenameModified = { fg = c.fg_dim, bg = c.bg2, bold = true }
      hl.MiniStatuscolumnSep            = { fg = c.bg3 }
      hl.MiniStatuscolumnSepCursor      = { fg = c.cinder }

      hl.RenderMarkdownCode             = { bg = c.bg_deep }
      hl.RenderMarkdownCodeBorder       = { bg = c.bg1 }
      hl.RenderMarkdownCodeInline       = { fg = c.sap, bg = c.bg_deep }
      hl.RenderMarkdownTableHead        = { fg = c.bg3 }
      hl.RenderMarkdownTableRow         = { fg = c.bg3 }
      hl.RenderMarkdownBullet           = { fg = c.ember }
      hl.RenderMarkdownChecked          = { fg = c.sap }
      hl.RenderMarkdownTodo             = { fg = c.frost }
      hl["@markup.strong"]              = { fg = c.cinder, bold = true }
      hl["@markup.italic"]              = { fg = c.cinder, italic = true }

      if transparent then
        hl.CursorLine  = { bg = "NONE" }
        hl.Folded      = { fg = c.comment }
        hl.PmenuBorder = { fg = c.bg5 }
        hl.Pmenu       = { fg = c.fg }
        hl.PmenuKind   = { fg = c.frost }
        hl.PmenuExtra  = { fg = c.fg_dim }
      end
    end,
  })

  vim.cmd.colorscheme("cendre")
end)
