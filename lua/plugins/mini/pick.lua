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
local pre_hooks = {}
local post_hooks = {}

local group = vim.api.nvim_create_augroup("minipick-hooks", { clear = true })
local create_minipick_auto_command = function(pattern, desc, hooks)
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = pattern,
    group = group,
    desc = desc,
    callback = function(...)
      local opts = MiniPick.get_picker_opts()
      if opts and opts.source then
        local hook = hooks[opts.source.name] or function(...) end
        hook(...)
      end
    end,
  })
end
create_minipick_auto_command("MiniPickStart", "pre-hook for source.name", pre_hooks)
create_minipick_auto_command("MiniPickStop", "post-hook for source.name", post_hooks)

-- Neovim config picker =====================================================

MiniPick.registry.config = function()
  return MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end

-- Colorscheme picker =======================================================

local selected_colorscheme -- Currently selected or original colorscheme

pre_hooks.Colorschemes = function()
  selected_colorscheme = vim.g.colors_name
end

post_hooks.Colorschemes = function()
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
