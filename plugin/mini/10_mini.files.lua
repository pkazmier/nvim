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
    desc = "Highlight target window while 'mini.files' is open",
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      -- Only highlight a window if there is more than one possible target
      local n_target_win = vim
        .iter(vim.api.nvim_tabpage_list_wins(0))
        :filter(function(w) return vim.api.nvim_win_get_config(w).relative == "" end)
        :fold(0, function(acc, _) return acc + 1 end)
      if n_target_win == 1 then return end

      -- Temporarily set 'winhighlight' and setup restore after closing explorer
      local target_win_id = MiniFiles.get_explorer_state().target_window
      local winhl_orig = vim.wo[target_win_id].winhighlight
      vim.wo[target_win_id].winhighlight = "Normal:Visual,SignColumn:Visual"
      local restore = function() vim.wo[target_win_id].winhighlight = winhl_orig end
      Config.new_autocmd("User", { once = true, pattern = "MiniFilesExplorerClose", callback = restore })
    end,
  })

  Config.minifiles_open_bufdir = function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path, true)
  end
end)
