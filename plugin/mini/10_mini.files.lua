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

  Config.minifiles_open_bufdir = function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path, true)
  end

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
    local target_win_id = MiniFiles.get_explorer_state().target_window
    local orig_hl_ns = vim.api.nvim_get_hl_ns({ winid = target_win_id })
    local restore = function() vim.api.nvim_win_set_hl_ns(target_win_id, orig_hl_ns ~= -1 and orig_hl_ns or 0) end
    vim.api.nvim_win_set_hl_ns(target_win_id, highlight_ns)
    Config.new_autocmd("User", { once = true, pattern = "MiniFilesExplorerClose", callback = restore })
  end

  local au_opts = { pattern = "MiniFilesExplorerOpen", callback = hl_target_win, desc = "Highlight target window" }
  Config.new_autocmd("User", au_opts)
end)
