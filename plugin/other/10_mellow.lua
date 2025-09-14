MiniDeps.later(function()
  vim.pack.add({ "https://github.com/mellow-theme/mellow.nvim" }, { load = true })
  local c = require("mellow.colors").dark

  vim.g.mellow_transparent = vim.fn.expand("$NEOVIM_TRANSPARENT") == "1"
  vim.g.mellow_italic_keywords = true
  vim.g.mellow_bold_functions = true

  -- stylua: ignore
  vim.g.mellow_highlight_overrides = {
    Delimiter                      = { fg = c.gray03 },

    -- FIXME: this is a test.
    MiniHipatternsFixmeBody        = { fg = c.cyan },
    MiniHipatternsFixme            = { fg = c.bg, bg = c.cyan },
    MiniHipatternsFixmeColon       = { bg = c.cyan, fg = c.cyan, bold = true },

    -- HACK: this is a test.
    MiniHipatternsHackBody         = { fg = c.red },
    MiniHipatternsHack             = { fg = c.bg, bg = c.red },
    MiniHipatternsHackColon        = { bg = c.red, fg = c.red, bold = true },

    -- NOTE: this is a note.
    MiniHipatternsNoteBody         = { fg = c.yellow },
    MiniHipatternsNote             = { fg = c.bg, bg = c.yellow },
    MiniHipatternsNoteColon        = { bg = c.yellow, fg = c.yellow, bold = true },

    -- TODO: this is a test.
    MiniHipatternsTodoBody         = { fg = c.blue },
    MiniHipatternsTodo             = { fg = c.bg, bg = c.blue },
    MiniHipatternsTodoColon        = { bg = c.blue, fg = c.blue, bold = true },

    MiniJump                       = { sp = c.yellow, undercurl = true },

    MiniStatuslineDirectory        = { fg = c.gray05 },
    MiniStatuslineFilenameModified = { fg = c.red, bold = true },

    NormalNC                       = { link = "Normal" },

    RenderMarkdownBullet           = { fg = c.cyan },
    RenderMarkdownCodeBorder       = { bg = c.black },
    RenderMarkdownTableHead        = { fg = c.gray03 },
    RenderMarkdownTableRow         = { fg = c.gray03 },

    Search                         = { sp = c.bright_yellow, underdouble = true },

    ["@markup.heading"]            = { fg = c.bright_cyan, bold = true },
    ["@markup.heading.1"]          = { italic = false },
    ["@markup.heading.2"]          = { italic = false },
    ["@markup.heading.3"]          = { italic = false },
    ["@markup.heading.4"]          = { italic = false },
    ["@markup.heading.5"]          = { italic = false },
    ["@markup.heading.6"]          = { italic = false },
    ["@markup.strong"]             = { fg = c.cyan, bold = true },
    ["@markup.italic"]             = { fg = c.cyan, italic = true },

    ["@lsp.typemod.type.defaultLibrary"] = { fg = c.bright_red },
  }
  -- vim.cmd.colorscheme("mellow")
end)
