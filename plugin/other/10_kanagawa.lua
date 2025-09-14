MiniDeps.later(function()
  vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" }, { load = true })
  require("kanagawa").setup({
    colors = {
      palette = {
        oldWhite = "#C7C19F", -- slightly less yellow
        fujiWhite = "#CFCAB0", -- slightly dimmer
      },
      theme = {
        wave = {
          ui = {
            float = {
              bg = "#1a1a22",
              bg_border = "#1a1a22",
            },
          },
        },
      },
    },
    overrides = function(colors)
      local t = colors.theme
      local c = colors.palette
      return {
        BlinkCmpLabelMatch = { fg = t.syn.fun, bold = true },
        MiniClueDescGroup = { fg = c.crystalBlue },
        MiniClueNextKey = { fg = c.oniViolet },
        MiniClueNextKeyWithPostkeys = { fg = c.sakuraPink },

        MiniHipatternsFixmeBody = { fg = t.diag.error },
        MiniHipatternsFixme = { fg = c.bg, bg = t.diag.error },
        MiniHipatternsFixmeColon = { bg = t.diag.error, fg = t.diag.error, bold = true },
        MiniHipatternsHackBody = { fg = t.diag.warning },
        MiniHipatternsHack = { fg = c.bg, bg = t.diag.warning },
        MiniHipatternsHackColon = { bg = t.diag.warning, fg = t.diag.warning, bold = true },
        MiniHipatternsNoteBody = { fg = t.diag.info },
        MiniHipatternsNote = { fg = c.bg, bg = t.diag.info },
        MiniHipatternsNoteColon = { bg = t.diag.info, fg = t.diag.info, bold = true },
        MiniHipatternsTodoBody = { fg = t.diag.hint },
        MiniHipatternsTodo = { fg = c.bg, bg = t.diag.hint },
        MiniHipatternsTodoColon = { bg = t.diag.hint, fg = t.diag.hint, bold = true },

        MiniFilesTitleFocused = { fg = t.ui.fg_dim, bold = true },

        MiniMapNormal = { fg = t.ui.nontext, bg = t.ui.float.bg },

        MiniPickMatchRanges = { fg = t.syn.fun, bold = true },

        MiniStarterInactive = { fg = c.fujiGray },
        MiniStarterItemBullet = { fg = c.dragonBlue, bold = true },
        MiniStarterItemPrefix = { fg = c.carpYellow, bold = true },
        MiniStarterQuery = { fg = c.crystalBlue, bold = true },
        MiniStarterSection = { fg = c.waveAqua1, bold = true },
        MiniStarterHeader = { fg = c.springBlue },

        MiniStatuslineModeNormal = { fg = t.ui.bg, bg = c.springBlue },
        MiniStatuslineFileinfo = { bg = t.ui.bg_visual },
        MiniStatuslineDevinfo = { bg = t.ui.bg_visual },
        MiniStatuslineDirectory = { fg = c.oldWhite },
        MiniStatuslineFilename = { fg = c.fujiWhite, bold = true },
        MiniStatuslineFilenameModified = { fg = c.fujiWhite, bold = true },

        MiniTablineCurrent = { fg = c.springBlue, bg = t.ui.bg_p1, bold = true },
        MiniTablineModifiedCurrent = { fg = t.ui.bg_p1, bg = c.springBlue, bold = true },

        RenderMarkdownBullet = { fg = t.syn.string },
        RenderMarkdownCode = { bg = t.ui.float.bg },
        RenderMarkdownCodeBorder = { bg = c.waveBlue1 },
        RenderMarkdownTableHead = { fg = c.oniViolet },
        RenderMarkdownTableRow = { fg = c.oniViolet },

        ["@markup.heading"] = { fg = t.syn.string },
        ["@markup.strong"] = { fg = t.syn.string, bold = true },
        ["@markup.italic"] = { fg = t.syn.string, italic = true },
      }
    end,
  })
  -- vim.cmd.colorscheme("kanagawa")
end)
