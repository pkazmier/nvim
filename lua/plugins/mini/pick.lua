require("mini.pick").setup({
  window = {
    config = {
      border = "single",
    },
  },
})

vim.ui.select = MiniPick.ui_select

MiniPick.registry.config = function()
  return MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end

MiniPick.registry.colorschemes = function()
  local colorschemes = vim.fn.getcompletion("", "color")
  return MiniPick.start({
    source = {
      items = colorschemes,
      choose = function(item)
        vim.cmd("colorscheme " .. item)
      end,
    },
  })
end
