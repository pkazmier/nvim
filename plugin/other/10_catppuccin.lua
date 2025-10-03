MiniDeps.later(function()
  vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }, { load = true })
  require("catppuccin").setup({
    default_integrations = false,
    integrations = {
      cmp = true,
      markdown = true,
      mason = true,
      mini = { enabled = true },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      semantic_tokens = true,
      treesitter = true,
      treesitter_context = true,
    },
    highlight_overrides = {
      all = function(colors)
        local overrides = {
          Folded = { bg = colors.surface0 },
          Comment = { fg = colors.overlay0, style = { "italic" } },
          RenderMarkdownCodeBorder = { bg = colors.surface0 },
          RenderMarkdownCode = { bg = colors.mantle },
          RenderMarkdownTableHead = { fg = colors.overlay0 },
          RenderMarkdownTableRow = { fg = colors.overlay0 },
          ["@markup.quote"] = { fg = colors.maroon, style = { "italic" } }, -- block quotes
        }
        return overrides
      end,
      mocha = function(colors)
        local overrides = {
          Headline = { style = { "bold" } },
          FloatTitle = { fg = colors.green },
          WinSeparator = { fg = colors.surface1, style = { "bold" } },
          CursorLineNr = { fg = colors.lavender, style = { "bold" } },
          LeapBackdrop = { link = "MiniJump2dDim" },
          LeapLabel = { fg = colors.green, style = { "bold" } },
          MsgArea = { fg = colors.overlay2 },
          CmpItemAbbrMatch = { fg = colors.green, style = { "bold" } },
          CmpItemAbbrMatchFuzzy = { fg = colors.green, style = { "bold" } },

          -- Mini customizations
          MiniClueDescGroup = { fg = colors.mauve },
          MiniClueDescSingle = { fg = colors.sapphire },
          MiniClueNextKey = { fg = colors.yellow },
          MiniClueNextKeyWithPostkeys = { fg = colors.red, style = { "bold" } },

          MiniFilesCursorLine = { fg = nil, bg = colors.surface0, style = { "bold" } },
          MiniFilesFile = { fg = colors.overlay2 },
          MiniFilesTitleFocused = { fg = colors.sky, style = { "bold" } },

          MiniHipatternsFixmeBody = { fg = colors.red, bg = colors.base },
          MiniHipatternsFixmeColon = { bg = colors.red, fg = colors.red, style = { "bold" } },
          MiniHipatternsHackBody = { fg = colors.yellow, bg = colors.base },
          MiniHipatternsHackColon = { bg = colors.yellow, fg = colors.yellow, style = { "bold" } },
          MiniHipatternsNoteBody = { fg = colors.sky, bg = colors.base },
          MiniHipatternsNoteColon = { bg = colors.sky, fg = colors.sky, style = { "bold" } },
          MiniHipatternsTodoBody = { fg = colors.teal, bg = colors.base },
          MiniHipatternsTodoColon = { bg = colors.teal, fg = colors.teal, style = { "bold" } },

          MiniIndentscopeSymbol = { fg = colors.sapphire },

          MiniJump = { bg = colors.green, fg = colors.base, style = { "bold" } },
          MiniJump2dSpot = { fg = colors.peach },
          MiniJump2dSpotAhead = { fg = colors.mauve },
          MiniJump2dSpotUnique = { fg = colors.peach },

          MiniMapNormal = { fg = colors.overlay2, bg = colors.mantle },

          MiniPickMatchCurrent = { fg = nil, bg = colors.surface0, style = { "bold" } },
          MiniPickMatchRanges = { fg = colors.green, style = { "bold" } },
          MiniPickNormal = { fg = colors.overlay2, bg = colors.mantle },
          MiniPickPrompt = { fg = colors.sky, style = { "bold" } },

          MiniStarterHeader = { fg = colors.sapphire },
          MiniStarterInactive = { fg = colors.surface2, style = {} },
          MiniStarterItem = { fg = colors.overlay2, bg = nil },
          MiniStarterItemBullet = { fg = colors.surface2 },
          MiniStarterItemPrefix = { fg = colors.pink },
          MiniStarterQuery = { fg = colors.red, style = { "bold" } },
          MiniStarterSection = { fg = colors.peach, style = { "bold" } },

          MiniStatuslineDirectory = { fg = colors.overlay1, bg = colors.surface0 },
          MiniStatuslineFilename = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineFilenameModified = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineInactive = { fg = colors.overlay1, bg = colors.surface0 },

          MiniSurround = { fg = nil, bg = colors.yellow },

          MiniTablineCurrent = { fg = colors.yellow, bg = colors.base, style = { "bold" } },
          MiniTablineFill = { bg = colors.mantle },
          MiniTablineHidden = { fg = colors.overlay1, bg = colors.surface0 },
          MiniTablineModifiedCurrent = { fg = colors.base, bg = colors.yellow, style = { "bold" } },
          MiniTablineModifiedHidden = { fg = colors.base, bg = colors.subtext0 },
          MiniTablineModifiedVisible = { fg = colors.base, bg = colors.subtext0, style = { "bold" } },
          MiniTablineTabpagesection = { fg = colors.base, bg = colors.mauve, style = { "bold" } },
          MiniTablineVisible = { fg = colors.overlay1, bg = colors.surface0, style = { "bold" } },
        }
        for _, hl in ipairs({ "Headline", "rainbow" }) do
          for i, c in ipairs({ "green", "sapphire", "mauve", "peach", "red", "yellow" }) do
            overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
          end
        end
        return overrides
      end,
      -- This is a comment and for the love of ...
      macchiato = function(colors)
        local overrides = {
          CurSearch = { bg = colors.peach },
          CursorLineNr = { fg = colors.blue, style = { "bold" } },
          IncSearch = { bg = colors.peach },
          MsgArea = { fg = colors.overlay1 },
          Search = { bg = colors.mauve, fg = colors.base },
          TreesitterContext = { bg = colors.surface0 },
          TreesitterContextBottom = { sp = colors.surface1, style = { "underline" } },
          WinSeparator = { fg = colors.surface1, style = { "bold" } },
          ["@string.special.symbol"] = { link = "Special" },
          ["@constructor.lua"] = { fg = colors.pink },

          -- Better markdown code block compat w/ mini.hues
          KazCodeBlock = { bg = colors.crust },

          -- Links to Comment by default, but that has italics
          LeapBackdrop = { link = "MiniJump2dDim" },
          LeapLabel = { fg = colors.peach, style = { "bold" } },

          -- Mini customizations
          MiniClueDescGroup = { fg = colors.pink },
          MiniClueDescSingle = { fg = colors.sapphire },
          MiniClueNextKey = { fg = colors.text, style = { "bold" } },
          MiniClueNextKeyWithPostkeys = { fg = colors.red, style = { "bold" } },

          MiniFilesCursorLine = { fg = nil, bg = colors.surface1, style = { "bold" } },
          MiniFilesFile = { fg = colors.overlay2 },
          MiniFilesTitleFocused = { fg = colors.peach, style = { "bold" } },

          -- Highlight patterns for highlighting the whole line and hiding colon.
          -- See https://github.com/echasnovski/mini.nvim/discussions/783
          MiniHipatternsFixmeBody = { fg = colors.red, bg = colors.base },
          MiniHipatternsFixmeColon = { bg = colors.red, fg = colors.red, style = { "bold" } },
          MiniHipatternsHackBody = { fg = colors.yellow, bg = colors.base },
          MiniHipatternsHackColon = { bg = colors.yellow, fg = colors.yellow, style = { "bold" } },
          MiniHipatternsNoteBody = { fg = colors.sky, bg = colors.base },
          MiniHipatternsNoteColon = { bg = colors.sky, fg = colors.sky, style = { "bold" } },
          MiniHipatternsTodoBody = { fg = colors.teal, bg = colors.base },
          MiniHipatternsTodoColon = { bg = colors.teal, fg = colors.teal, style = { "bold" } },

          MiniIndentscopeSymbol = { fg = colors.sapphire },

          MiniJump = { fg = colors.mantle, bg = colors.pink },
          MiniJump2dSpot = { fg = colors.peach },
          MiniJump2dSpotAhead = { fg = colors.mauve },
          MiniJump2dSpotUnique = { fg = colors.peach },

          MiniMapNormal = { fg = colors.overlay2, bg = colors.mantle },

          MiniPickBorderText = { fg = colors.blue },
          MiniPickMatchCurrent = { fg = colors.text, bg = colors.surface1, style = { "bold" } },
          MiniPickMatchRanges = { fg = colors.text, style = { "bold" } },
          MiniPickNormal = { fg = colors.overlay2, bg = colors.mantle },
          MiniPickPrompt = { fg = colors.sky },

          MiniStarterInactive = { fg = colors.overlay0, style = {} },
          MiniStarterItem = { fg = colors.overlay2, bg = nil },
          MiniStarterItemBullet = { fg = colors.surface2 },
          MiniStarterItemPrefix = { fg = colors.text },
          MiniStarterQuery = { fg = colors.text, style = { "bold" } },
          MiniStarterSection = { fg = colors.mauve, style = { "bold" } },

          MiniStatuslineDirectory = { fg = colors.overlay1, bg = colors.surface0 },
          MiniStatuslineFilename = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineFilenameModified = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineInactive = { fg = colors.overlay1, bg = colors.surface0 },

          MiniSurround = { fg = nil, bg = colors.yellow },

          MiniTablineCurrent = { fg = colors.blue, bg = colors.base, style = { "bold" } },
          MiniTablineFill = { bg = colors.mantle },
          MiniTablineHidden = { fg = colors.overlay1, bg = colors.surface0 },
          MiniTablineModifiedCurrent = { fg = colors.base, bg = colors.blue, style = { "bold" } },
          MiniTablineModifiedHidden = { fg = colors.base, bg = colors.subtext0 },
          MiniTablineModifiedVisible = { fg = colors.base, bg = colors.subtext0, style = { "bold" } },
          MiniTablineTabpagesection = { fg = colors.base, bg = colors.mauve, style = { "bold" } },
          MiniTablineVisible = { fg = colors.overlay1, bg = colors.surface0, style = { "bold" } },
        }
        for _, hl in ipairs({ "Headline", "rainbow" }) do
          for i, c in ipairs({ "blue", "pink", "lavender", "green", "peach", "flamingo" }) do
            overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
          end
        end
        return overrides
      end,
    },
    color_overrides = {
      macchiato = {
        rosewater = "#F5B8AB",
        flamingo = "#F29D9D",
        pink = "#AD6FF7",
        mauve = "#FF8F40",
        red = "#E66767",
        maroon = "#EB788B",
        peach = "#FAB770",
        yellow = "#FACA64",
        green = "#70CF67",
        teal = "#4CD4BD",
        sky = "#61BDFF",
        sapphire = "#4BA8FA",
        blue = "#00BFFF",
        lavender = "#00BBCC",
        text = "#C1C9E6",
        subtext1 = "#A3AAC2",
        subtext0 = "#8E94AB",
        overlay2 = "#7D8296",
        overlay1 = "#676B80",
        overlay0 = "#464957",
        surface2 = "#3A3D4A",
        surface1 = "#2F313D",
        surface0 = "#1D1E29",
        base = "#0b0b12",
        mantle = "#11111a",
        crust = "#191926",
      },
    },
  })
  -- vim.cmd.colorscheme("catppuccin-macchiato")
end)
