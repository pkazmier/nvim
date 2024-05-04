local utils = require("utils")
require("neodev").setup()

for name, icon in pairs(utils.icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

vim.diagnostic.config({
  float = { border = "single" },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    -- TODO: nvim 0.10
    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
    -- prefix = "icons",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = utils.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = utils.icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = utils.icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = utils.icons.diagnostics.Info,
    },
  },
})

local servers = {
  gopls = {},
  marksman = {},
  basedpyright = {
    settings = {
      basedpyright = {
        typeCheckingMode = "off",
      },
    },
  },
  ruff_lsp = {
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
    end,
  },
  lua_ls = {
    settings = {
      Lua = {
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

require("mason").setup()
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
})
