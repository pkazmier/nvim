-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable cursorline in inactive windows
local no_cursorlines = { "neo-tree", "trouble", "snacks_dashboard" }
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  callback = function()
    if vim.tbl_contains(no_cursorlines, vim.bo.filetype) then
      return
    end
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  callback = function()
    if vim.tbl_contains(no_cursorlines, vim.bo.filetype) then
      return
    end
    vim.opt_local.cursorline = false
  end,
})

-- Set buffer local options based on filetype
local filetype_options = {
  go = {
    tabstop = 8,
    shiftwidth = 8,
    expandtab = false,
  },
  haskell = {
    tabstop = 4,
    shiftwidth = 4,
  },
}
vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(filetype_options),
  callback = function(ev)
    for opt, val in pairs(filetype_options[ev.match]) do
      vim.opt_local[opt] = val
    end
  end,
})
