require("conform").setup({
  notify_on_error = true,
  format_after_save = function(bufnr)
    if vim.g.disable_autoformat then
      return
    end
    local disable_filetypes = { c = true, cpp = true }
    return {
      timeout_ms = 5000,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform can also run multiple formatters sequentially
    python = { "isort", "black" },
    -- Run *until* a formatter is found.
    markdown = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
  },
})

vim.api.nvim_create_user_command("FormatToggle", function(_)
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  local state = vim.g.disable_autoformat and "disabled" or "enabled"
  vim.notify("Auto-save " .. state)
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})
