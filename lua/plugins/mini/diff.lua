local M = {}

require("mini.diff").setup({
  view = {
    -- style = "sign",
    -- priority = 10,
  },
  mappings = {
    apply = "<leader>gh",
    reset = "<leader>gH",
  },
  options = {
    wrap_goto = true,
  },
})

M.to_qf = function()
  vim.fn.setqflist(MiniDiff.export("qf"))
  vim.cmd("copen")
end

return M
