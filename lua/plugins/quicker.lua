-- ---------------------------------------------------------------------------
-- quicker
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function()
  vim.pack.add({ { src = "https://github.com/stevearc/quicker.nvim" } })
  require("quicker").setup({
    keys = {
      {
        ">",
        "<Cmd>lua require('quicker').expand({ add_to_existing = true })<Cr>",
        desc = "Expand quickfix context",
      },
      { "<", "<Cmd>lua require('quicker').collapse()<Cr>", desc = "Collapse quickfix context" },
    },
  })
end)
