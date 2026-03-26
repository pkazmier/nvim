-- ---------------------------------------------------------------------------
-- lume
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ { src = "https://github.com/danfry1/lume" } })
  -- vim.cmd.packadd("lume-dev")

  require("lume").setup({
    palette_overrides = {
      -- Medium Contrast
      -- backgrounds = {
      --   crust = "#141029",
      --   mantle = "#19162B",
      --   base = "#1F1B33",
      --   surface0 = "#2B2640",
      --   surface1 = "#342F4A",
      --   surface2 = "#3F3A57",
      -- },
      -- special = {
      --   selection = "#484066",
      -- },

      -- Low Contrast
      -- backgrounds = {
      --   crust = "#181529",
      --   mantle = "#1E1B2B",
      --   base = "#242133",
      --   surface0 = "#312D40",
      --   surface1 = "#3B384A",
      --   surface2 = "#484457",
      -- },
      -- special = {
      --   selection = "#524D66",
      -- },
    },

    custom_highlights = function(colors, variant)
      local fg, bg, ac = colors.foregrounds, colors.backgrounds, colors.accents

      -- stylua: ignore
      return {
        -- Dim the line numbers as they are too bright for my taste
        LineNr                         = { fg = bg.surface2 },
        TreesitterContextLineNumber    = { fg = bg.surface2 },

        PmenuBorder                    = { fg = bg.surface2, bg = bg.surface0 },
        
        -- Make the sign column bg transparent because the default in lume
        -- assigns the Normal background, which looks weird on non-current
        -- windows because there is no such thing SignColumnNC. So we fix
        -- that by setting the bg to NONE which inherits the bg instead.
        SignColumn                     = { bg = "NONE" },
        
        ["@property"]                  = { fg = ac.teal },
        ["@lsp.type.variable"]         = { link = "@lsp" },
        ["@lsp.type.property"]         = { link = "@property" },
        
        LeapBackdrop                   = { link = "MiniJump2dDim" },
        LeapLabel                      = { fg = ac.honey, bold = true },
        
        MiniClueDescGroup              = { fg = ac.sky },
        MiniClueSeparator              = { fg = bg.surface2 },
        
        MiniJump                       = { sp = ac.honey, fg = "NONE", bg = "NONE", undercurl = true },

        MiniStarterItemPrefix          = { fg = ac.teal, bold = true },
        MiniStarterInactive            = { fg = fg.comment },
        MiniStarterQuery               = { fg = ac.peach, bold = true },
        MiniStarterSection             = { fg = ac.sky, bold = true },
        MiniStarterFooter              = { fg = fg.comment, italic = true },
        
        -- surface1 looks better than mantle for those with `laststatus=2`
        MiniStatuslineInactive         = { fg = fg.overlay, bg = bg.surface1 },
        MiniStatuslineDirectory        = { fg = fg.overlay, bg = bg.mantle },
        MiniStatuslineFilename         = { fg = fg.subtext, bg = bg.mantle, bold = true },
        MiniStatuslineFilenameModified = { fg = fg.subtext, bg = bg.mantle, bold = true },
        MiniStatuslineDevinfo          = { fg = fg.subtext, bg = bg.surface2 },
        MiniStatuslineFileinfo         = { fg = fg.subtext, bg = bg.surface2 },

        MiniTablineCurrent             = { fg = ac.sage,    bg = bg.base, bold = true },
        MiniTablineHidden              = { fg = fg.comment, bg = bg.crust },
        MiniTablineVisible             = { fg = fg.text,    bg = bg.mantle },
        MiniTablineFill                = { bg = bg.crust },
        MiniTablineModifiedCurrent     = { fg = bg.crust,   bg = ac.sage, bold= true },
        MiniTablineModifiedVisible     = { fg = bg.crust,   bg = fg.text },
        MiniTablineModifiedHidden      = { fg = bg.crust,   bg = fg.comment },
        
        RenderMarkdownCode             = { bg = bg.surface0 },
        RenderMarkdownCodeBorder       = { bg = bg.surface1 },
        RenderMarkdownCodeInline       = { fg = ac.sage, bg = bg.surface0 },
        RenderMarkdownChecked          = { fg = ac.sage },
        RenderMarkdownUnchecked        = { fg = ac.lavender },
        RenderMarkdownTodo             = { fg = ac.sky },
        RenderMarkdownLink             = { fg = ac.teal },
        RenderMarkdownTableHead        = { fg = bg.surface2 },
        RenderMarkdownTableRow         = { fg = bg.surface2 },
      }
    end,
  })
end)
