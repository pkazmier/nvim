-- ---------------------------------------------------------------------------
-- mini.files
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")

local M = {}

-- Open explorer at the current buffer's directory; bound to <leader>ef.
function M.open_bufdir()
  local files = require("mini.files")
  local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
  files.open(path, true)
end

loader.later(function()
  local files = require("mini.files")
  files.setup({ windows = { preview = true } })

  autocmds.new("User", {
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      files.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
      files.set_bookmark("m", vim.fn.stdpath("data") .. "/site/pack/core/opt/mini.nvim", { desc = "mini.nvim" })
      files.set_bookmark("p", vim.fn.stdpath("data") .. "/site/pack/core/opt", { desc = "Plugins" })
      files.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
    end,
  })

  -- Create hl namespace to highlight 'mini.files' target window
  local highlight_ns = vim.api.nvim_create_namespace("highlight_minifiles_target")
  vim.api.nvim_set_hl(highlight_ns, "Normal", { link = "Visual" })
  vim.api.nvim_set_hl(highlight_ns, "SignColumn", { link = "Visual" })

  local hl_target_win = function()
    -- Only highlight a window if there is more than one possible target
    local possible_targets = vim
      .iter(vim.api.nvim_tabpage_list_wins(0))
      :filter(function(w) return vim.api.nvim_win_get_config(w).relative == "" end)
      :fold(0, function(acc, _) return acc + 1 end)
    if possible_targets == 1 then return end

    -- Temporarily set a hl namespace in target and setup restore after closing explorer
    local target_win_id = files.get_explorer_state().target_window
    local orig_hl_ns = vim.api.nvim_get_hl_ns({ winid = target_win_id })
    local restore = function() vim.api.nvim_win_set_hl_ns(target_win_id, orig_hl_ns ~= -1 and orig_hl_ns or 0) end
    vim.api.nvim_win_set_hl_ns(target_win_id, highlight_ns)
    autocmds.new("User", { once = true, pattern = "MiniFilesExplorerClose", callback = restore })
  end

  local au_opts = { pattern = "MiniFilesExplorerOpen", callback = hl_target_win, desc = "Highlight target window" }
  autocmds.new("User", au_opts)
end)

return M
