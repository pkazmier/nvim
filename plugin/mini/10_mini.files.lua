-- ---------------------------------------------------------------------------
-- mini.files
-- ---------------------------------------------------------------------------

local H = {}
Config.later(function()
  require("mini.files").setup({
    windows = { preview = true },
  })

  Config.new_autocmd("User", {
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
      MiniFiles.set_bookmark("m", vim.fn.stdpath("data") .. "/site/pack/core/opt/mini.nvim", { desc = "mini.nvim" })
      MiniFiles.set_bookmark("p", vim.fn.stdpath("data") .. "/site/pack/core/opt", { desc = "Plugins" })
      MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
    end,
  })

  Config.new_autocmd("User", {
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      -- Only highlight a window if there is more than one possible target
      if H.count_splits() == 0 then return end
      local target = MiniFiles.get_explorer_state().target_window
      local orig_winhighlight = vim.api.nvim_get_option_value("winhighlight", { win = target })
      vim.api.nvim_set_option_value("winhighlight", "Normal:Visual,SignColumn:Visual", { win = target })
      Config.new_autocmd("User", {
        once = true,
        pattern = "MiniFilesExplorerClose",
        callback = function() vim.api.nvim_set_option_value("winhighlight", orig_winhighlight, { win = target }) end,
      })
    end,
  })

  Config.minifiles_open_bufdir = function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path, true)
  end
end)

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Returns the number of splits (non-floating windows) on screen
H.count_splits = function()
  return vim
    .iter(vim.api.nvim_tabpage_list_wins(0))
    :filter(function(w) return vim.api.nvim_win_get_config(w).relative == "" end)
    :fold(-1, function(acc, _) return acc + 1 end)
end
