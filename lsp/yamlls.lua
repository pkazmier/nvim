-- Kill the yamlls if editing a helm chart because we want helmls instead.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buffer = args.buf ---@type number
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client.name == "yamlls" and vim.bo[buffer].filetype == "helm" then
      vim.schedule(function()
        vim.cmd("LspStop ++force " .. args.data.client_id)
      end)
    end
  end,
})
return {}
