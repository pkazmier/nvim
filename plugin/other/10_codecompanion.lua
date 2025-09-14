MiniDeps.later(function()
  if Config.copilot_disable then
    return
  end

  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/olimorris/codecompanion.nvim",
  }, { load = true })

  require("codecompanion").setup({})

  local ids = {} -- CodeCompanion request ID --> MiniNotify notification ID
  local group = vim.api.nvim_create_augroup("CodeCompanionMiniNotifyHooks", {})

  local function format_request_status(ev)
    local name = ev.data.adapter.formatted_name or ev.data.adapter.name
    local msg = name .. " " .. ev.data.strategy .. " request..."
    local level, hl_group = "INFO", "DiagnosticInfo"
    if ev.data.status then
      msg = msg .. ev.data.status
      if ev.data.status ~= "success" then
        level, hl_group = "ERROR", "DiagnosticError"
      end
    end
    return msg, level, hl_group
  end

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(ev)
      local msg, level, hl_group = format_request_status(ev)
      ids[ev.data.id] = MiniNotify.add(msg, level, hl_group)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(ev)
      local msg, level, hl_group = format_request_status(ev)
      local mini_id = ids[ev.data.id]
      if mini_id then
        ids[ev.data.id] = nil
        MiniNotify.update(mini_id, { msg = msg, level = level, hl_group = hl_group })
      else
        mini_id = MiniNotify.add(msg, level, hl_group)
      end
      vim.defer_fn(function()
        MiniNotify.remove(mini_id)
      end, 5000)
    end,
  })
end)
