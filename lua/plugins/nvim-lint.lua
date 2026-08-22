-- ---------------------------------------------------------------------------
-- nvim-lint
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")

loader.later(function()
  vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-lint" } })
  local lint = require("lint")
  lint.linters_by_ft = {
    markdown = { "markdownlint-cli2" },
    sql = { "sqruff" },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
  }

  autocmds.new({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function() lint.try_lint() end,
  })
end)
