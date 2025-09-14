MiniDeps.later(function()
  vim.pack.add({ "https://github.com/vague2k/vague.nvim" }, { load = true })
  require("vague").setup({
    plugins = {
      lsp = {
        diagnostic_ok = "italic",
        diagnostic_hint = "italic",
        diagnostic_info = "italic",
        diagnostic_warn = "italic",
        diagnostic_error = "italic",
      },
    },
    -- stylua: ignore
    on_highlights = function(hl, c)
      hl.Added                          = { fg = c.plus }
      hl.Changed                        = { fg = c.delta }
      hl.Directory                      = { fg = c.keyword }
      hl.CurSearch                      = { fg = c.bg,          bg = c.constant }
      hl.IncSearch                      = { fg = c.bg,          bg = c.constant }
      -- hl.QuickFixLine                   = { fg = c.constant,    gui = "bold" }
      hl.StatusLine                     = { fg = c.operator,    bg = c.line }
      hl.WinSeparator                   = { fg = c.line }

      hl.LeapBackdrop                   = { fg = c.comment }
      hl.LeapLabel                      = { fg = c.delta,       gui = "bold" }

      hl.MiniClueDescGroup              = { fg = c.keyword }
      hl.MiniClueNextKey                = { fg = c.parameter,   gui = "bold" }
      hl.MiniClueNextKeyWithPostkeys    = { fg = c.func,        gui = "bold" }

      hl.MiniFilesTitleFocused          = { fg = c.constant,    gui = "bold" }

      hl.MiniHipatternsFixmeBody        = { fg = c.error }
      hl.MiniHipatternsHackBody         = { fg = c.warning }
      hl.MiniHipatternsNoteBody         = { fg = c.plus }
      hl.MiniHipatternsTodoBody         = { fg = c.hint }
      hl.MiniHipatternsFixme            = { fg = c.bg,          bg = c.error }
      hl.MiniHipatternsHack             = { fg = c.bg,          bg = c.warning }
      hl.MiniHipatternsNote             = { fg = c.bg,          bg = c.plus }
      hl.MiniHipatternsTodo             = { fg = c.bg,          bg = c.hint }
      hl.MiniHipatternsFixmeColon       = { bg = c.error,       fg = c.error,       gui = "bold" }
      hl.MiniHipatternsHackColon        = { bg = c.warning,     fg = c.warning,     gui = "bold" }
      hl.MiniHipatternsNoteColon        = { bg = c.plus,        fg = c.plus,        gui = "bold" }
      hl.MiniHipatternsTodoColon        = { bg = c.hint,        fg = c.hint,        gui = "bold" }

      hl.MiniIndentscopeSymbol          = { fg = c.comment }

      hl.MiniJump                       = { sp = c.delta,       gui = "undercurl"}

      hl.MiniMapNormal                  = { fg = c.comment,     bg = c.line }

      hl.MiniPickHeader                 = { fg = c.keyword,     gui = "bold" }
      hl.MiniPickMatchCurrent           = { fg = c.constant,    bg = c.line }
      hl.MiniPickMatchRanges            = { fg = c.delta,       gui = "bold" }
      hl.MiniPickPrompt                 = { fg = c.constant }

      hl.MiniStarterInactive            = { fg = c.comment }
      hl.MiniStarterItemPrefix          = { fg = c.string }
      hl.MiniStarterQuery               = { fg = c.delta,       gui = "bold" }
      hl.MiniStarterHeader              = { fg = c.keyword,     gui = "bold" }
      hl.MiniStarterSection             = { fg = c.func,        gui = "bold" }

      hl.MiniStatuslineDevinfo          = { fg = c.fg,          bg = c.search}
      hl.MiniStatuslineDirectory        = { fg = c.operator,    bg = c.line }
      hl.MiniStatuslineFileinfo         = { fg = c.fg,          bg = c.search}
      hl.MiniStatuslineFilename         = { fg = c.operator,    bg = c.line, gui = "bold" }
      hl.MiniStatuslineFilenameModified = { fg = c.delta,       bg = c.line, gui = "bold" }
      hl.MiniStatuslineInactive         = { fg = c.comment,     bg = c.line }
      hl.MiniStatuslineModeCommand      = { fg = c.bg,          bg = c.string }
      hl.MiniStatuslineModeInsert       = { fg = c.bg,          bg = c.plus}
      hl.MiniStatuslineModeNormal       = { fg = c.bg,          bg = c.keyword }
      hl.MiniStatuslineModeOther        = { fg = c.bg,          bg = c.keyword }
      hl.MiniStatuslineModeReplace      = { fg = c.bg,          bg = c.func}
      hl.MiniStatuslineModeVisual       = { fg = c.bg,          bg = c.parameter }

      hl.MiniTablineCurrent             = { fg = c.constant,    bg = c.line,        sp = c.line, gui = "bold,underline" }
      hl.MiniTablineFill                = {                     bg = c.bg,          sp = c.line, gui = "underline" }
      hl.MiniTablineHidden              = { fg = c.comment,     bg = c.line,        sp = c.line, gui = "underline" }
      hl.MiniTablineVisible             = { fg = c.operator,    bg = c.line,        sp = c.line, gui = "underline" }
      hl.MiniTablineModifiedCurrent     = { fg = c.bg,          bg = c.constant,    sp = c.line, gui = "bold,underline" }
      hl.MiniTablineModifiedHidden      = { fg = c.line,        bg = c.comment,     sp = c.line, gui = "underline" }
      hl.MiniTablineModifiedVisible     = { fg = c.bg,          bg = c.operator,    sp = c.line, gui = "underline" }
      hl.MiniTablineTabpagesection      = { fg = c.fg,          bg = c.search,      sp = c.line, gui = "underline" }

      hl.RenderMarkdownBullet           = { fg = c.plus }
      hl.RenderMarkdownTableRow         = { fg = c.keyword }
      hl.RenderMarkdownCode             = { bg = c.line }

      hl.TreesitterContext              = { bg = c.line }
      hl.TreesitterContextBottom        = { sp = c.comment,     gui = "underdotted" }
      hl.TreesitterContextLineNumber    = { fg = c.comment,     bg = c.line }

      hl["@markup.strong"]              = { fg = c.keyword,     gui = "bold" }
      hl["@markup.italic"]              = { fg = c.keyword,     gui = "italic" }
      hl["@markup.heading.1"]           = { fg = c.constant,    gui = "bold" }
      hl["@markup.heading.2"]           = { fg = c.parameter,   gui = "bold" }
      hl["@markup.heading.3"]           = { fg = c.type,        gui = "bold" }
      hl["@markup.heading.4"]           = { fg = c.operator,    gui = "bold" }
      hl["@markup.heading.5"]           = { fg = c.plus,        gui = "bold" }
      hl["@markup.heading.6"]           = { fg = c.func,        gui = "bold" }

      -- Compute a nice background color for markup headings based on the
      -- foreground color of each level. Use mini.colors to adjust the colors.
      local groups = {}
      for i = 1, 6 do
        groups["h"..i] = hl["@markup.heading."..i]
      end
      local cs = require("mini.colors").as_colorscheme({ groups = groups })
      cs = cs:chan_invert('lightness', { gamut_clip = 'cusp'})
      cs = cs:chan_add('lightness', -5)
      for i = 1, 6 do
        local bg = cs.groups["h"..i].fg
        hl["RenderMarkdownH"..i.."Bg"] = { bg = bg }
      end
    end,
  })
end)
