local M = {}
local H = {}

require("mini.files").setup({
  windows = {
    preview = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "g.", H.toggle_dotfiles, { buffer = buf_id, desc = "Toggle Hidden Files" })
    --
    -- NOTE: Interfere's with the bookmark feature in mini.files.
    -- MiniClue.ensure_buf_triggers(args.data.buf_id)
    --
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    H.lsp_on_rename(event.data.from, event.data.to)
  end,
})

M.cwd = function()
  MiniFiles.open(vim.uv.cwd(), true)
end

M.bufdir = function()
  local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
  MiniFiles.open(path, true)
end

H.show_dotfiles = true
H.filter_show = function(_)
  return true
end

H.filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

H.toggle_dotfiles = function()
  H.show_dotfiles = not H.show_dotfiles
  local new_filter = H.show_dotfiles and H.filter_show or H.filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

-- [LSP utilities from LazyVim]
---@param from string
---@param to string
H.lsp_on_rename = function(from, to)
  local changes = { files = { {
    oldUri = vim.uri_from_fname(from),
    newUri = vim.uri_from_fname(to),
  } } }

  local clients = vim.lsp.get_clients and vim.lsp.get_clients() or vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
    if client.supports_method("workspace/didRenameFiles") then
      client.notify("workspace/didRenameFiles", changes)
    end
  end
end

return M
