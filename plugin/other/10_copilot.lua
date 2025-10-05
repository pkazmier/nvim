MiniDeps.later(function()
  -- if Config.copilot_disable then
  --   return
  -- end

  vim.api.nvim_create_autocmd({ "PackChanged" }, {
    pattern = "*/copilot.lua",
    callback = function(ev)
      if ev.data.kind == "install" or ev.data.kind == "update" then
        if vim.fn.exists(":Copilot") > 0 then
          vim.cmd("Copilot auth")
        end
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
