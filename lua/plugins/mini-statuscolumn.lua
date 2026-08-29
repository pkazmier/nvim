-- ---------------------------------------------------------------------------
-- mini.statuscolumn (WIP -- the module itself lives in lua/ms.lua)
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function()
  local ms = require("mini.statuscolumn")
  local spec = {
    { format = "=slf", sep = "▏" },
    { ltype = "virt", lnum = "•" },
    { ltype = "wrap", lnum = "↳" },
    { win = "inactive", sep = " " },
  }
  ms.setup({ content = ms.gen_content.main(spec) })
  vim.api.nvim_set_hl(0, "Folded", { link = "Normal" })
  vim.api.nvim_set_hl(0, "MiniStatuscolumnSepCursor", { link = "LineNr" })
end)
