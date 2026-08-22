-- ---------------------------------------------------------------------------
-- conform
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

local M = {}

-- Module-local state (only conform reads it)
local disable_autoformat = false

-- Toggle format-on-save; bound to '\f' in keymaps
function M.toggle()
  disable_autoformat = not disable_autoformat
  vim.notify("Auto-format " .. (disable_autoformat and "disabled" or "enabled"))
end

loader.later(function()
  vim.pack.add({ { src = "https://github.com/stevearc/conform.nvim" } })
  require("conform").setup({
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disabled via the toggle above
      if disable_autoformat then return end
      return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
    -- Map of filetype to formatters
    formatters_by_ft = {
      css = { "prettierd" },
      fennel = { "fnlfmt" },
      html = { "prettierd" },
      javascript = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      markdown = { "prettierd" },
      -- python = { "isort", "black" },  -- testing ruff instead now
      sql = { "sqruff" },
    },
  })
end)

return M
