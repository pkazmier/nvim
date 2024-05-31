local M = {}
local H = {}

require("mini.files").setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 30,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "g.", H.toggle_dotfiles, { buffer = buf_id, desc = "Toggle Hidden Files" })
    MiniClue.ensure_buf_triggers(args.data.buf_id)
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
  MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
end

local show_dotfiles = true
H.filter_show = function(_)
  return true
end

H.filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

H.toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and H.filter_show or H.filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

-- [LSP utilities from LazyVim]
---@param from string
---@param to string
H.lsp_on_rename = function(from, to)
  local clients = vim.lsp.get_clients and vim.lsp.get_clients() or vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

return M
