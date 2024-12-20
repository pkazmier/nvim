require("lazydev").setup()

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
--   callback = function(event)
--     local client = vim.lsp.get_client_by_id(event.data.client_id)
--     if client and client.supports_method("textDocument/inlayHint") then
--       vim.lsp.inlay_hint.enable()
--     end
--   end,
-- })

vim.diagnostic.config({
  float = { border = "single" },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
})

local servers = {
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = false,
          parameterNames = false,
          rangeVariableTypes = true,
        },
      },
    },
  },
  marksman = {},
  basedpyright = {
    settings = {
      basedpyright = {
        typeCheckingMode = "off",
      },
    },
  },
  harper_ls = {
    filetypes = { "markdown", "html" },
    settings = {
      ["harper-ls"] = {
        linters = {
          spell_check = false,
          sentence_capitalization = false,
        },
      },
    },
  },
  ruff = {
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
    end,
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "hs" },
        },
        hint = {
          enable = true,
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua",
  "prettierd",
  "black",
  "isort",
  "markdownlint",
})

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
capabilities = vim.tbl_deep_extend("force", capabilities, {
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  },
})

require("mason").setup()
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.handlers = vim.tbl_deep_extend("force", {}, handlers, server.handlers or {})
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
})
