MiniDeps.later(function()
  if Config.copilot_disable then
    return
  end

  -- Add post hook to run after first-time install
  Config.new_autocmd({ "PackChanged" }, {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name == "copilot.lua" and kind == "install" then
        vim.cmd.packadd("copilot.lua")
        vim.cmd("Copilot auth")
      end
    end,
  })

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
