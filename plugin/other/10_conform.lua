MiniDeps.later(function()
  vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { load = true })

  require("conform").setup({
    -- Map of filetype to formatters
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if Config.disable_autoformat then
        return
      end
      return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
    -- stylua: ignore
    formatters_by_ft = {
      css        = { "prettierd" },
      html       = { "prettierd" },
      javascript = { "prettierd" },
      json       = { "prettierd" },
      yaml       = { "prettierd" },
      lua        = { "stylua" },
      markdown   = { "prettierd" },
      -- python     = { "isort", "black" },  -- testing ruff instead now
      sql        = { "sqruff" },
    },
  })

  vim.api.nvim_create_user_command("FormatToggle", function(_)
    Config.disable_autoformat = not Config.disable_autoformat
    local state = vim.g.disable_autoformat and "disabled" or "enabled"
    vim.notify("Auto-save " .. state)
  end, {
    desc = "Toggle autoformat-on-save",
  })
end)
