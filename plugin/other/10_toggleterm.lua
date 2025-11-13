-- ---------------------------------------------------------------------------
-- toggleterm
-- ---------------------------------------------------------------------------

MiniDeps.later(function()
  vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" }, { load = true })

  require("toggleterm").setup({
    direction = "float",
    highlights = {
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "FloatBorder" },
    },
    float_opts = {
      border = { " ", "▁", " ", " ", " ", "▔", " ", " " },
      winblend = 0,
    },
    open_mapping = [[<c-\>]],
    on_create = function(term)
      local opts = { buffer = term.bufnr }
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
    end,
  })

  Config.toggleterm_lazygit = function()
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
