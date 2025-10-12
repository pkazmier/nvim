-- Auto command helper to add autocommands to my custom group
local custom_group = vim.api.nvim_create_augroup("kaz-custom-config", {})
_G.Config.new_autocmd = function(event, opts)
  opts.group = opts.group or custom_group
  vim.api.nvim_create_autocmd(event, opts)
end

-- Auto toggle cursorline
Config.new_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})

Config.new_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})
