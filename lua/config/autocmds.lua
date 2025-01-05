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

-- HACK: Show the virtual text above line 1 for L1 headers.
-- I use the border option on headings in render-markdown, which looks great
-- except on L1 headers on line 1 because the virtual text above line 1 is
-- not displayed upon entering the buffer.
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*.md",
  callback = function()
    local ctrl_y = vim.api.nvim_replace_termcodes("<c-y>", true, false, true)
    vim.schedule(function()
      local current_position = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys(ctrl_y, "n", true)
      vim.api.nvim_win_set_cursor(0, current_position)
    end)
  end,
})

-- Set buffer local options based on filetype
local filetype_options = {
  go = {
    opt_local = {
      tabstop = 8,
      shiftwidth = 8,
      expandtab = false,
    },
  },
  haskell = {
    opt_local = {
      tabstop = 4,
      shiftwidth = 4,
    },
  },
  markdown = {
    b = {
      snacks_indent = false,
      trouble_lualine = false,
    },
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(filetype_options),
  callback = function(ev)
    for option_type, options in pairs(filetype_options[ev.match]) do
      for opt, val in pairs(options) do
        vim[option_type][opt] = val
      end
    end
  end,
})
