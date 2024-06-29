require("mini.pick").setup({
  window = {
    config = {
      border = "single",
    },
  },
})

vim.ui.select = MiniPick.ui_select

-- Picker pre- and post-hooks ===============================================

-- Keys should be a picker source.name. Value is a callback function that
-- accepts same arguments as User autocommand callback.
local hooks = {
  pre_hooks = {},
  post_hooks = {},
}

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "MiniPickStart",
  group = vim.api.nvim_create_augroup("minipick-pre-hooks", { clear = true }),
  desc = "Invoke pre_hook for specific picker based on source.name.",
  callback = function(...)
    local opts = MiniPick.get_picker_opts() or {}
    local pre_hook = hooks.pre_hooks[opts.source.name] or function(...) end
    pre_hook(...)
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "MiniPickStop",
  group = vim.api.nvim_create_augroup("minipick-post-hooks", { clear = true }),
  desc = "Invoke post_hook for specific picker based on source.name.",
  callback = function(...)
    local opts = MiniPick.get_picker_opts()
    if opts then
      local post_hook = hooks.post_hooks[opts.source.name] or function(...) end
      post_hook(...)
    else
      vim.notify("MiniPick.get_picker_opts() returned nil")
    end
  end,
})

-- Neovim config picker =====================================================

MiniPick.registry.config = function()
  return MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end

-- Colorscheme picker =======================================================

local selected_colorscheme -- Currently selected or original colorscheme

hooks.pre_hooks.Colorschemes = function()
  selected_colorscheme = vim.g.colors_name
end

hooks.post_hooks.Colorschemes = function()
  vim.schedule(function()
    vim.cmd("colorscheme " .. selected_colorscheme)
  end)
end

MiniPick.registry.colorschemes = function()
  local colorschemes = vim.fn.getcompletion("", "color")
  return MiniPick.start({
    source = {
      name = "Colorschemes",
      items = colorschemes,
      choose = function(item)
        selected_colorscheme = item
      end,
      preview = function(buf_id, item)
        vim.cmd("colorscheme " .. item)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { item })
      end,
    },
  })
end
