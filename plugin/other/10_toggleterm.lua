MiniDeps.later(function()
  vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" }, { load = true })

  require("toggleterm").setup({
    -- direction = "float",
    highlights = { FloatBorder = { link = "FloatBorder" } },
    open_mapping = [[<c-\>]],
    on_create = function(term)
      local opts = { buffer = term.bufnr }
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
    end,
    shading_factor = -20,
  })

  Config.lazygit_toggle = function()
    local lazygit = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      hidden = true,
      highlights = { FloatBorder = { link = "FloatBorder" } },
      direction = "float",
      on_open = function(term)
        vim.keymap.del("t", "<Esc><Esc>", { buffer = term.bufnr })
      end,
    })
    lazygit:toggle()
  end
end)
