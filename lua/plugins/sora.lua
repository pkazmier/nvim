-- ---------------------------------------------------------------------------
-- sora colorscheme
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

-- stylua: ignore
loader.now(function()
  vim.pack.add({ { src = "https://github.com/Aejkatappaja/sora" } })
  -- vim.cmd.packadd("sora-dev")

  local transparent = false

  require("sora").setup({
    background = "hard",
    transparent = transparent,
    on_highlights = function(hl, c)
      -- Leap
      hl.LeapLabel                      = { fg = c.accent, bold = true }
      hl.LeapBackdrop                   = { fg = c.fg_gutter }

      -- I have customized mini.statusline to allow me to style the filename
      -- and directory separately as well as whether or not the filename has
      -- been modified.
      hl.MiniStatuslineDirectory        = { fg = c.fg_dim, bg = c.bg_elevated }
      hl.MiniStatuslineFilename         = { fg = c.fg_dim, bg = c.bg_elevated, bold = true }
      hl.MiniStatuslineFilenameModified = { fg = c.fg_dim, bg = c.bg_elevated, bold = true }

      -- Unreleased mini module
      hl.MiniStatuscolumnSep            = { fg = c.guide }

      if transparent then
        hl.CursorLine  = { bg = "NONE" }
        hl.Folded      = { fg = c.comment }
        hl.PmenuBorder = { fg = c.border }
        hl.Pmenu       = { fg = c.fg }
        hl.PmenuKind   = { fg = c.purple }
        hl.PmenuExtra  = { fg = c.fg_dim }
      end
    end,
  })

  -- vim.cmd.colorscheme("sora")
end)
