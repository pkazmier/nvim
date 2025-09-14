MiniDeps.later(function()
  require("mini.files").setup({
    mappings = { mark_set = "M" },
    windows = { preview = true },
  })

  local minifiles_augroup = vim.api.nvim_create_augroup("ec-mini-files", {})
  vim.api.nvim_create_autocmd("User", {
    group = minifiles_augroup,
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
end)
