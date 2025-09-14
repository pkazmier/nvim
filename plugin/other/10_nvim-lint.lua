MiniDeps.later(function()
  vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { load = true })
  local lint = require("lint")
  lint.linters_by_ft = {
    markdown = { "markdownlint-cli2" },
    sql = { "sqruff" },
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
