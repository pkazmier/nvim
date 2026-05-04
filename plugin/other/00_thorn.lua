-- ---------------------------------------------------------------------------
-- tokyonight colorscheme
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ { src = "https://github.com/pkazmier/thorn.nvim", version = "refactor/theme-change" } })
  require("thorn").setup({
    on_highlights = function(hl, p)
      hl.PmenuSel = { bg = p.cursorline, bold = true }
      hl.TreesitterContextLineNumber = { fg = p.number, bg = p.bg_float }
      hl.LeapLabel = { fg = p.bg, bg = p.orange, bold = true }

      -- -- mini.clue
      -- hl.MiniClueNextKey = { fg = p.green_6 }
      -- hl.MiniClueDescGroup = { fg = p.blue }
      -- hl.MiniClueDescSingle = { fg = p.fg }
      --
      -- -- mini.cmdline
      -- hl.MiniCmdlinePeekSep = { bg = p.bg_float }
      --
      -- -- mini.diff
      -- hl.MiniDiffSignAdd = { fg = p.git.add }
      -- hl.MiniDiffSignChange = { fg = p.git.change }
      -- hl.MiniDiffSignDelete = { fg = p.git.delete }
      --
      -- -- mini.files
      -- hl.MiniFilesCursorLine = { link = "PmenuSel" }
      -- hl.MiniFilesTitleFocused = { fg = p.blue }
      --
      -- -- mini.icons
      -- hl.MiniIconsAzure = { fg = p.blue }
      -- hl.MiniIconsBlue = { fg = p.green_2 }
      -- hl.MiniIconsCyan = { fg = p.green_6 }
      -- hl.MiniIconsGreen = { fg = p.green_4 }
      -- hl.MiniIconsGrey = { fg = p.gray }
      -- hl.MiniIconsOrange = { fg = p.orange }
      -- hl.MiniIconsPurple = { fg = p.green_0 }
      -- hl.MiniIconsRed = { fg = p.red }
      -- hl.MiniIconsYellow = { fg = p.yellow }
      --
      -- -- mini.map
      -- hl.MiniMapNormal = { fg = p.gray, bg = p.bg_float }
      --
      -- -- mini.pick
      -- hl.MiniPickMatchCurrent = { link = "PmenuSel" }
      -- hl.MiniPickMatchMarked = { bg = p.diff.add }
      -- hl.MiniPickMatchRanges = { link = "PmenuMatch" }
      -- hl.MiniPickPrompt = { fg = p.blue, bg = p.bg_float }
      -- hl.MiniPickPromptPrefix = { fg = p.green_1, bg = p.bg_float }
      --
      -- -- mini.starter
      -- hl.MiniStarterFooter = { fg = p.green_5 }
      -- hl.MiniStarterInactive = { fg = p.green_5 }
      -- hl.MiniStarterSection = { fg = p.blue }
      -- hl.MiniStarterItemPrefix = { fg = p.yellow }
      -- hl.MiniStarterQuery = { fg = p.orange }
      --
      -- -- mini.statusline
      -- hl.MiniStatuslineModeNormal = { bg = p.statusbar.fg, fg = p.bg, bold = true }
      -- hl.MiniStatuslineModeInsert = { bg = p.orange, fg = p.bg, bold = true }
      -- hl.MiniStatuslineModeVisual = { bg = p.blue, fg = p.bg, bold = true }
      -- hl.MiniStatuslineModeReplace = { bg = p.red, fg = p.bg, bold = true }
      -- hl.MiniStatuslineModeCommand = { bg = p.yellow, fg = p.bg, bold = true }
      -- hl.MiniStatuslineModeOther = { bg = p.orange, fg = p.bg, bold = true }
      -- hl.MiniStatuslineDevInfo = { bg = p.statusbar.sep, fg = p.statusbar.fg }
      -- hl.MiniStatuslineFileInfo = { bg = p.statusbar.sep, fg = p.statusbar.fg }
      hl.MiniStatuslineDirectory = { bg = p.statusbar.bg, fg = p.gray }
      hl.MiniStatuslineFilename = { bg = p.statusbar.bg, fg = p.gray, bold = true }
      -- hl.MiniStatuslineInactive = { bg = p.statusbar.bg, fg = p.gray }
      --
      -- -- mini.tabline
      -- hl.MiniTablineFill = { link = "TabLineFill" }
      -- hl.MiniTablineCurrent = { fg = p.green_6, bg = p.statusbar.bg, bold = true }
      -- hl.MiniTablineVisible = { fg = p.green_6, bg = p.statusbar.bg }
      -- hl.MiniTablineHidden = { fg = p.green_5, bg = p.statusbar.bg }
      -- hl.MiniTablineModifiedCurrent = { bg = p.green_6, fg = p.statusbar.bg, bold = true }
      -- hl.MiniTablineModifiedHidden = { bg = p.green_5, fg = p.statusbar.bg }
      -- hl.MiniTablineModifiedVisible = { bg = p.green_6, fg = p.statusbar.bg }
      --
      -- -- Mini Trailspace
      -- hl.MiniTrailspace = { bg = p.red }
    end,
  })
  vim.cmd.colorscheme("thorn")
end)
