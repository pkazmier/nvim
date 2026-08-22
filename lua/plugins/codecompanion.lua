-- ---------------------------------------------------------------------------
-- codecompanion
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")
local options = require("config.options")

loader.later(function()
  if options.copilot_disable then return end

  vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
  })

  require("codecompanion").setup({
    interactions = {
      chat = {
        keymaps = {
          completion = {
            modes = { i = "<C-/>" },
            callback = "keymaps.completion",
            description = "Completion menu",
          },
        },
      },
    },
  })

  -- -------------------------------------------------------------------------
  -- Use MiniNotify to track start / stop of requests
  -- -------------------------------------------------------------------------

  local notify = require("mini.notify")

  local ids = {} -- CodeCompanion request ID --> MiniNotify notification ID

  local function format_request_status(ev)
    local name = ev.data.adapter.formatted_name or ev.data.adapter.name
    local status = ev.data.status
    local msg = name .. " " .. ev.data.interaction .. " request..." .. (status or "")
    if status and status ~= "success" then return msg, "ERROR", "DiagnosticError" end
    return msg, "INFO", "DiagnosticInfo"
  end

  autocmds.new("User", {
    pattern = "CodeCompanionRequestStarted",
    callback = function(ev)
      local msg, level, hl_group = format_request_status(ev)
      ids[ev.data.id] = notify.add(msg, level, hl_group)
    end,
  })

  autocmds.new("User", {
    pattern = "CodeCompanionRequestFinished",
    callback = function(ev)
      local msg, level, hl_group = format_request_status(ev)
      local existing = ids[ev.data.id]
      local mini_id = existing or notify.add(msg, level, hl_group)
      if existing then
        ids[ev.data.id] = nil
        notify.update(existing, { msg = msg, level = level, hl_group = hl_group })
      end
      vim.defer_fn(function() notify.remove(mini_id) end, 5000)
    end,
  })
end)
