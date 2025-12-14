-- ---------------------------------------------------------------------------
-- nvim-lint
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { load = true })
  local lint = require("lint")
  lint.linters_by_ft = {
    markdown = { "markdownlint-cli2" },
    sql = { "sqruff" },
    sh = { "shellcheck" },
  }

  Config.new_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function() lint.try_lint() end,
  })
end)
