-- ---------------------------------------------------------------------------
-- mini.notify
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now(
  function()
    require("mini.notify").setup({
      lsp_progress = { enable = false },
      window = { max_width_share = 0.75, winblend = 0 },
    })
  end
)
