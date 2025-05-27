local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

now_if_args(function() -- treesitter
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })
  add("nvim-treesitter/nvim-treesitter-textobjects")
  add("nvim-treesitter/nvim-treesitter-context")

  local ensure_installed = {
    "bash",
    "css",
    "go",
    "helm",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "toml",
    "yaml",
  }

  require("nvim-treesitter.configs").setup({
    auto_install = true,
    ensure_installed = ensure_installed,
    highlight = { enable = true },
    textobjects = { enable = false },
    indent = { enable = false },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  })

  require("treesitter-context").setup()
end)

later(function() -- blink
  add({
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    hooks = {
      post_install = Config.build_blink,
      post_checkout = Config.build_blink,
    },
  })

  require("blink.cmp").setup({
    keymap = {
      preset = "enter",
      -- defer these to mini.keymap binding
      ["<Tab>"] = { "fallback" },
      ["<S-Tab>"] = { "fallback" },
    },
    completion = {
      list = { selection = { preselect = false } },
      documentation = { auto_show = true },
      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = MiniIcons.get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = MiniIcons.get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },
    appearance = { nerd_font_variant = "normal" },
    snippets = { preset = "mini_snippets" },
    signature = { enabled = true },
  })
end)

later(function() -- copilot
  if not vim.g.kaz_copilot then
    return
  end

  add({
    source = "zbirenbaum/copilot.lua",
    hooks = {
      post_checkout = function()
        vim.cmd("Copilot auth")
      end,
    },
  })

  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end)

later(function() -- mason
  add("williamboman/mason.nvim")
  require("mason").setup()
end)

later(function() -- conform
  add("stevearc/conform.nvim")

  require("conform").setup({
    -- Map of filetype to formatters
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      markdown = { "prettierd" },
      javascript = { "prettierd" },
      json = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
  })

  vim.api.nvim_create_user_command("FormatToggle", function(_)
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    local state = vim.g.disable_autoformat and "disabled" or "enabled"
    vim.notify("Auto-save " .. state)
  end, {
    desc = "Toggle autoformat-on-save",
  })
end)

later(function() -- lazydev
  add("folke/lazydev.nvim")
  require("lazydev").setup()
end)

later(function() -- leap
  add("ggandor/leap.nvim")
  require("leap.user").set_repeat_keys("<CR>", "<BS>")
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
end)

later(function() -- lsp
  add("neovim/nvim-lspconfig")

  vim.diagnostic.config({
    -- float = { border = "single" },
    underline = false,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "",
    },
    severity_sort = true,
  })

  -- All language servers are expected to be installed with 'mason.vnim'
  vim.lsp.enable({
    "gopls",
    "lua_ls",
    "basedpyright",
    "marksman",
    "ruff",
    "harper_ls",
    "helm_ls",
    "rust_analyzer",
    "jsonls",
    "yamlls",
  })

  vim.lsp.config["*"] = {
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
  }
end)

later(function() -- render-markdown
  add("MeanderingProgrammer/render-markdown.nvim")
  require("render-markdown").setup({
    render_modes = { "n", "no", "c", "t", "i", "ic" },
    checkbox = {
      enable = true,
      position = "inline",
    },
    code = {
      sign = false,
      -- position = "right",
      width = "full",
      -- min_width = min_width,
      left_pad = 3,
      right_pad = 1,
    },
    heading = {
      -- backgrounds = {},
      sign = false,
      border = true,
      -- width = "block",
      -- min_width = min_width,
      -- below = "▔",
      -- above = "▁",
      left_pad = 0,
      right_pad = 4,
      position = "overlay",
      icons = {
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
      },
    },
  })
end)

later(function() -- nvim-autopairs
  add("windwp/nvim-autopairs")
  require("nvim-autopairs").setup()
end)

later(function() -- nvim-lint
  add("mfussenegger/nvim-lint")
  local lint = require("lint")
  lint.linters_by_ft = {
    markdown = { "markdownlint-cli2" },
    sql = { "sqlfluff" },
    sh = { "shellcheck" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })
end)

later(function() -- toggleterm
  add("akinsho/toggleterm.nvim")

  require("toggleterm").setup({
    direction = "float",
    open_mapping = [[<c-\>]],
    on_create = function(term)
      local opts = { buffer = term.bufnr }
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
    end,
    shading_factor = -20,
  })

  Config.lazygit_toggle = function()
    local lazygit = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      on_open = function(term)
        vim.keymap.del("t", "<Esc><Esc>", { buffer = term.bufnr })
      end,
    })
    lazygit:toggle()
  end
end)

now(function() -- vague
  add({ source = "vague2k/vague.nvim" })
  require("vague").setup({
    -- stylua: ignore
    on_highlights = function(hl, c)
      hl.CurSearch                      = { fg = c.bg,          bg= c.constant }
      hl.Directory                      = { fg = c.keyword }
      hl.IncSearch                      = { fg = c.bg,          bg= c.constant }
      hl.LeapBackdrop                   = { fg = c.comment }
      hl.LeapLabel                      = { fg = c.delta,       gui = "bold" }
      hl.StatusLine                     = { fg = c.operator,    bg = c.line }
      hl.WinSeparator                   = { fg = c.line }

      hl.MiniClueDescGroup              = { fg = c.type }
      hl.MiniClueNextKey                = { fg = c.parameter,   gui = "bold" }
      hl.MiniClueNextKeyWithPostkeys    = { fg = c.func,        gui = "bold" }

      hl.MiniFilesTitleFocused          = { fg = c.constant,    gui = "bold" }

      hl.MiniHipatternsFixme            = { fg = c.bg,          bg = c.error }
      hl.MiniHipatternsFixmeBody        = { fg = c.error }
      hl.MiniHipatternsFixmeColon       = { bg = c.error,       fg = c.error,       gui = "bold" }
      hl.MiniHipatternsHack             = { fg = c.bg,          bg = c.warning }
      hl.MiniHipatternsHackBody         = { fg = c.warning }
      hl.MiniHipatternsHackColon        = { bg = c.warning,     fg = c.warning,     gui = "bold" }
      hl.MiniHipatternsNote             = { fg = c.bg,          bg = c.plus }
      hl.MiniHipatternsNoteBody         = { fg = c.plus }
      hl.MiniHipatternsNoteColon        = { bg = c.plus,        fg = c.plus,        gui = "bold" }
      hl.MiniHipatternsTodo             = { fg = c.bg,          bg = c.hint }
      hl.MiniHipatternsTodoBody         = { fg = c.hint }
      hl.MiniHipatternsTodoColon        = { bg = c.hint,        fg = c.hint,        gui = "bold" }

      hl.MiniIndentscopeSymbol          = { fg = c.comment }
      hl.MiniJump                       = { sp = c.delta,       gui = "undercurl"}
      hl.MiniMapNormal                  = { fg = c.comment,     bg = c.line }

      -- Picker
      hl.MiniPickMatchCurrent           = { fg = c.constant,    bg = c.line }
      hl.MiniPickMatchRanges            = { fg = c.delta,       gui = "bold" }
      hl.MiniPickPrompt                 = { fg = c.constant }

      -- Starter
      hl.MiniStarterInactive            = { fg = c.comment }
      hl.MiniStarterItemPrefix          = { fg = c.string }
      hl.MiniStarterQuery               = { fg = c.delta,       gui = "bold" }
      hl.MiniStarterHeader              = { fg = c.keyword,     gui = "bold" }
      hl.MiniStarterSection             = { fg = c.func,        gui = "bold" }

      -- Statusline
      hl.MiniStatuslineDevinfo          = { fg = c.fg,          bg = c.search}
      hl.MiniStatuslineDirectory        = { fg = c.operator,    bg = c.line }
      hl.MiniStatuslineFileinfo         = { fg = c.fg,          bg = c.search}
      hl.MiniStatuslineFilename         = { fg = c.operator,    bg = c.line, gui = "bold" }
      hl.MiniStatuslineFilenameModified = { fg = c.operator,    bg = c.line, gui = "bold" }
      hl.MiniStatuslineInactive         = { fg = c.comment,     bg = c.line }
      hl.MiniStatuslineModeCommand      = { fg = c.fg,          bg = c.comment }
      hl.MiniStatuslineModeInsert       = { fg = c.bg,          bg = c.plus}
      hl.MiniStatuslineModeNormal       = { fg = c.bg,          bg = c.keyword }
      hl.MiniStatuslineModeOther        = { fg = c.bg,          bg = c.keyword }
      hl.MiniStatuslineModeReplace      = { fg = c.bg,          bg = c.func}
      hl.MiniStatuslineModeVisual       = { fg = c.bg,          bg = c.constant}

      -- Tabline
      hl.MiniTablineCurrent             = { fg = c.constant,    bg = c.line,        sp = c.line, gui = "bold,underline" }
      hl.MiniTablineFill                = {                     bg = c.bg,          sp = c.line, gui = "underline" }
      hl.MiniTablineHidden              = { fg = c.comment,     bg = c.line,        sp = c.line, gui = "underline" }
      hl.MiniTablineVisible             = { fg = c.operator,    bg = c.line,        sp = c.line, gui = "underline" }
      hl.MiniTablineModifiedCurrent     = { fg = c.bg,          bg = c.constant,    sp = c.line, gui = "bold,underline" }
      hl.MiniTablineModifiedHidden      = { fg = c.line,        bg = c.comment,     sp = c.line, gui = "underline" }
      hl.MiniTablineModifiedVisible     = { fg = c.bg,          bg = c.operator,    sp = c.line, gui = "underline" }
      hl.MiniTablineTabpagesection      = { fg = c.fg,          bg = c.comment,     sp = c.line, gui = "bold,underline" }

      -- Markdown
      hl["@markup.heading.1"]           = { fg = c.keyword }
      hl["@markup.heading.2"]           = { fg = c.parameter }
      hl["@markup.heading.3"]           = { fg = c.type }
      hl["@markup.heading.4"]           = { fg = c.operator }
      hl["@markup.heading.5"]           = { fg = c.func }
      hl["@markup.heading.6"]           = { fg = c.property }
      hl.RenderMarkdownH1Bg             = { bg = c.line }
      hl.RenderMarkdownH2Bg             = { bg = c.line }
      hl.RenderMarkdownH3Bg             = { bg = c.line }
      hl.RenderMarkdownH4Bg             = { bg = c.line }
      hl.RenderMarkdownH5Bg             = { bg = c.line }
      hl.RenderMarkdownH6Bg             = { bg = c.line }
      hl.RenderMarkdownTableRow         = { fg = c.keyword }
      hl.RenderMarkdownCode             = { bg = c.visual }

      -- Treesitter Context
      hl.TreesitterContext              = { bg = c.line }
      hl.TreesitterContextLineNumber    = { fg = c.comment,     bg = c.line }
      hl.TreesitterContextBottom        = { sp = c.comment,     gui = "underdotted" }
    end,
  })
  vim.cmd.colorscheme("vague")
end)

now_if_args(function() -- vim-helm
  add("towolf/vim-helm")
end)

later(function() -- zk
  add("zk-org/zk-nvim")
  local cmds = require("zk.commands")

  require("zk").setup({
    picker = "minipick",
    lsp = {
      config = {
        cmd = { "zk", "lsp" },
        name = "zk",
      },
      auto_attach = { enabled = true, filetypes = { "markdown" } },
    },
  })

  cmds.add("ZkNewMeeting", function(opts)
    opts = vim.tbl_extend("force", { dir = "meetings" }, opts or {})
    Config.new_meeting(opts)
  end)

  cmds.add("ZkFullTextSearch", function(opts)
    opts = opts or {}
    if not opts.match then
      opts.match = { vim.fn.input("Match: ") }
    end
    opts = vim.tbl_extend("keep", opts, {
      sort = { "created" },
    })
    cmds.get("ZkNotes")(opts)
  end)

  cmds.add("ZkPriorMeetings", function(_)
    local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)
    if #line == 1 then
      local meeting = line[1]:match("^# %d%d%d%d%-%d%d%-%d%d: (.+)")
      if meeting then
        local filter = 'title: "' .. meeting .. '"'
        local bufname = vim.api.nvim_buf_get_name(0)
        cmds.get("ZkNotes")({
          excludeHrefs = { bufname },
          sort = { "created" },
          match = { filter },
        })
      end
    end
  end)
end)

-- Other colorschemes I like to use
later(function() -- catppuccin
  add({ source = "catppuccin/nvim", name = "catppuccin" })
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
          KazCodeBlock = { bg = colors.mantle },
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
          MiniPickMatchCurrent = { fg = nil, bg = colors.surface1, style = { "bold" } },
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

later(function() -- everforest
  add("sainnhe/everforest")
  vim.g.everforest_float_style = "bright"
  vim.g.everforest_background = "medium"

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("custom_highlights_everforest", {}),
    pattern = "everforest",
    callback = function()
      -- stylua: ignore start
      local config  = vim.fn['everforest#get_configuration']()
      local palette = vim.fn['everforest#get_palette'](config.background, config.colors_override)
      local set_hl  = vim.fn['everforest#highlight']

      set_hl("BlinkCmpMenu",                   palette.none,   palette.bg3)
      set_hl("BlinkCmpMenuBorder",             palette.none,   palette.bg3)
      set_hl("BlinkCmpDoc",                    palette.none,   palette.bg3)
      set_hl("BlinkCmpDocBorder",              palette.none,   palette.bg3)
      set_hl("BlinkCmpDocSeparator",           palette.none,   palette.bg3)
      set_hl("BlinkCmpSignatureHelp",          palette.none,   palette.bg5)
      set_hl("BlinkCmpSignatureHelpBorder",    palette.none,   palette.bg5)
      set_hl("MiniPickMatchRanges",            palette.green,  palette.none,   "bold")
      set_hl("MiniTablineFill",                palette.none,   palette.bg1)
      set_hl("MiniTablineCurrent",             palette.blue,   palette.bg0,    "bold")
      set_hl("MiniTablineHidden",              palette.grey2,  palette.bg2)
      set_hl("MiniTablineModifiedCurrent",     palette.bg1,    palette.blue,   "bold")
      set_hl("MiniTablineModifiedHidden",      palette.bg1,    palette.grey2)
      set_hl("MiniTablineModifiedVisible",     palette.bg1,    palette.grey2,  "bold")
      set_hl("MiniTablineTabpagesection",      palette.bg0,    palette.aqua,   "bold")
      set_hl("MiniTablineVisible",             palette.grey2,  palette.bg2,    "bold")
      set_hl("MiniHipatternsFixmeBody",        palette.red,    palette.none)
      set_hl("MiniHipatternsFixmeColon",       palette.red,    palette.red,    "bold")
      set_hl("MiniHipatternsHackBody",         palette.yellow, palette.none)
      set_hl("MiniHipatternsHackColon",        palette.yellow, palette.yellow, "bold")
      set_hl("MiniHipatternsNoteBody",         palette.blue,   palette.none)
      set_hl("MiniHipatternsNoteColon",        palette.blue,   palette.blue,   "bold")
      set_hl("MiniHipatternsTodoBody",         palette.green,  palette.none)
      set_hl("MiniHipatternsTodoColon",        palette.green,  palette.green,  "bold")
      set_hl("MiniStatuslineDirectory",        palette.grey0,  palette.bg1)
      set_hl("MiniStatuslineFilename",         palette.grey2,  palette.bg1,    "bold")
      set_hl("MiniStatuslineFilenameModified", palette.blue,   palette.bg1,    "bold")
      set_hl("MiniStatuslineInactive",         palette.grey0,  palette.bg1)
      set_hl("MiniStatuslineDevinfo",          palette.grey2,  palette.bg3)
      set_hl("MiniStatuslineFileinfo",         palette.grey2,  palette.bg3)
      set_hl("MiniJump2dDim",                  palette.bg5,    palette.none)
      set_hl("MiniJump2dSpot",                 palette.orange, palette.bg_dim, "bold")
      set_hl("MiniJump2dSpotUnique",           palette.orange, palette.bg_dim, "bold")
      set_hl("MiniJump2dSpotAhead",            palette.yellow, palette.bg_dim)
      set_hl("RenderMarkdownH1Bg",             palette.none,   palette.bg_visual)
      set_hl("RenderMarkdownH2Bg",             palette.none,   palette.bg_red)
      set_hl("RenderMarkdownH3Bg",             palette.none,   palette.bg_yellow)
      set_hl("RenderMarkdownH4Bg",             palette.none,   palette.bg_green)
      set_hl("RenderMarkdownH5Bg",             palette.none,   palette.bg_blue)
      set_hl("RenderMarkdownH6Bg",             palette.none,   palette.bg2)
      set_hl("TreesitterContext",              palette.none,   palette.bg_dim)
      set_hl("TreesitterContextLineNumber",    palette.bg5,    palette.bg_dim)
      set_hl("TreesitterContextBottom",        palette.none,   palette.none, "underline", palette.bg1)
      --stylua: ignore end
    end,
  })
end)

later(function() -- gruvbox-material
  add("sainnhe/gruvbox-material")
  vim.g.gruvbox_material_float_style = "bright"
  vim.g.gruvbox_material_background = "medium"

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("custom_highlights_gruvboxmaterial", {}),
    pattern = "gruvbox-material",
    callback = function()
      -- stylua: ignore start
      local config  = vim.fn["gruvbox_material#get_configuration"]()
      local palette = vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
      local set_hl  = vim.fn["gruvbox_material#highlight"]

      set_hl("BlinkCmpMenu",                   palette.none,   palette.bg3)
      set_hl("BlinkCmpMenuBorder",             palette.none,   palette.bg3)
      set_hl("BlinkCmpDoc",                    palette.none,   palette.bg3)
      set_hl("BlinkCmpDocBorder",              palette.none,   palette.bg3)
      set_hl("BlinkCmpDocSeparator",           palette.none,   palette.bg3)
      set_hl("BlinkCmpSignatureHelp",          palette.none,   palette.bg5)
      set_hl("BlinkCmpSignatureHelpBorder",    palette.none,   palette.bg5)
      set_hl("LeapBackdrop",                   palette.bg5,    palette.none)
      set_hl("LeapLabel",                      palette.orange, palette.none,           "bold")
      set_hl("MiniPickMatchRanges",            palette.green,  palette.none,           "bold")
      set_hl("MiniTablineCurrent",             palette.blue,   palette.bg0,            "bold")
      set_hl("MiniTablineHidden",              palette.grey2,  palette.bg_statusline2)
      set_hl("MiniTablineModifiedCurrent",     palette.bg2,    palette.blue,           "bold")
      set_hl("MiniTablineModifiedHidden",      palette.bg2,    palette.grey2)
      set_hl("MiniTablineModifiedVisible",     palette.bg2,    palette.grey2,          "bold")
      set_hl("MiniTablineTabpagesection",      palette.bg0,    palette.aqua,           "bold")
      set_hl("MiniTablineVisible",             palette.grey2,  palette.bg_statusline2, "bold")
      set_hl("MiniHipatternsFixmeBody",        palette.red,    palette.none)
      set_hl("MiniHipatternsFixmeColon",       palette.red,    palette.red,            "bold")
      set_hl("MiniHipatternsHackBody",         palette.yellow, palette.none)
      set_hl("MiniHipatternsHackColon",        palette.yellow, palette.yellow,         "bold")
      set_hl("MiniHipatternsNoteBody",         palette.blue,   palette.none)
      set_hl("MiniHipatternsNoteColon",        palette.blue,   palette.blue,           "bold")
      set_hl("MiniHipatternsTodoBody",         palette.green,  palette.none)
      set_hl("MiniHipatternsTodoColon",        palette.green,  palette.green,          "bold")
      set_hl("MiniStatuslineDirectory",        palette.grey0,  palette.bg_statusline1)
      set_hl("MiniStatuslineFilename",         palette.grey2,  palette.bg_statusline1, "bold")
      set_hl("MiniStatuslineFilenameModified", palette.blue,   palette.bg_statusline1, "bold")
      set_hl("MiniStatuslineInactive",         palette.grey0,  palette.bg_statusline1)
      set_hl("MiniJump2dDim",                  palette.bg5,    palette.none)
      set_hl("MiniJump2dSpot",                 palette.orange, palette.bg_dim,         "bold")
      set_hl("MiniJump2dSpotUnique",           palette.orange, palette.bg_dim,         "bold")
      set_hl("MiniJump2dSpotAhead",            palette.yellow, palette.bg_dim)
      set_hl("RenderMarkdownH1Bg",             palette.none,   palette.bg_visual_red)
      set_hl("RenderMarkdownH2Bg",             palette.none,   palette.bg_visual_yellow)
      set_hl("RenderMarkdownH3Bg",             palette.none,   palette.bg_visual_blue)
      set_hl("RenderMarkdownH4Bg",             palette.none,   palette.bg_visual_green)
      set_hl("RenderMarkdownH5Bg",             palette.none,   palette.bg_current_word)
      set_hl("RenderMarkdownH6Bg",             palette.none,   palette.bg_current_word)
      set_hl("TreesitterContext",              palette.none,   palette.bg_dim)
      set_hl("TreesitterContextLineNumber",    palette.bg5,    palette.bg_dim)
      set_hl("TreesitterContextBottom",        palette.none,   palette.none, "underline", palette.bg1)
      --stylua: ignore end
    end,
  })
  -- vim.cmd.colorscheme("gruvbox-material")
end)

later(function() -- tokyonight
  add("folke/tokyonight.nvim")
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
    end,
  })
  -- vim.cmd.colorscheme("tokyonight-moon")
end)
