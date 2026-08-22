-- ---------------------------------------------------------------------------
-- mini.basics
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now(
  function()
    require("mini.basics").setup({
      mappings = { windows = true, move_with_alt = true },
      autocommands = { relnum_in_visual_mode = true },
    })
  end
)
