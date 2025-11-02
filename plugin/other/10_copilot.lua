-- ---------------------------------------------------------------------------
-- copilot
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  if Config.copilot_disable then
    return
  end

  vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" }, { load = true })
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end)
