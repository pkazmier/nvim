-- ---------------------------------------------------------------------------
-- Autocommand helper
-- ---------------------------------------------------------------------------

local custom_group = vim.api.nvim_create_augroup("my-custom-autocommands", {})

local M = {}

-- Add an autocommand to my custom group. NOTE: nvim DELETES an autocommand
-- whose callback returns a truthy value, so callbacks must not return one
-- (use `once = true` for genuine one-shots).
function M.new(event, opts)
  opts.group = opts.group or custom_group
  vim.api.nvim_create_autocmd(event, opts)
end

-- ---------------------------------------------------------------------------
-- Active Window Cursorline
-- ---------------------------------------------------------------------------
--
-- Show cursorline only in the current window. I find it annoying to see
-- cursorlines in other windows, so this autocommand will automatically
-- disable when leaving and enable when entering.
M.new({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})

M.new({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

return M
