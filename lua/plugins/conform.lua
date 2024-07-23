local no_lsp_fallback = {
  c = true,
  cpp = true,
}
require("conform").setup({
  notify_on_error = true,
  format_after_save = function(bufnr)
    if vim.g.disable_autoformat then
      return
    end
    local filetype = vim.bo[bufnr].filetype
    return {
      timeout_ms = 5000,
      lsp_format = no_lsp_fallback[filetype] and "never" or "fallback",
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform can also run multiple formatters sequentially
    python = { "isort", "black" }, -- ruff doesn't support sort on format ... sigh
    -- Run *until* a formatter is found.
    markdown = { "prettierd" },
    javascript = { "prettierd" },
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
