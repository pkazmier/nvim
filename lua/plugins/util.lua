return {
  {
    "sotte/presenting.nvim",
    ft = { "markdown" },
    config = function(_, opts)
      local presenting = require("presenting")
      presenting.setup(opts)
      Snacks.toggle({
        name = "Presentation Mode",
        get = function()
          return presenting._state ~= nil
        end,
        set = function(enabled)
          if enabled then
            presenting.start()
          else
            presenting.quit()
          end
        end,
      }):map("<leader>up")
    end,
  },
  {
    "jbyuki/venn.nvim",
    ft = { "markdown" },
    config = function(_, opts)
      Snacks.toggle({
        name = "Venn Diagram Mode",
        get = function()
          return vim.b.venn_enabled
        end,
        set = function(enabled)
          if enabled then
            vim.b.venn_enabled = true
            vim.opt_local.virtualedit = "all"
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
          else
            vim.b.venn_enabled = nil
            vim.opt_local.virtualedit = ""
            vim.api.nvim_buf_del_keymap(0, "n", "J")
            vim.api.nvim_buf_del_keymap(0, "n", "K")
            vim.api.nvim_buf_del_keymap(0, "n", "L")
            vim.api.nvim_buf_del_keymap(0, "n", "H")
            vim.api.nvim_buf_del_keymap(0, "v", "f")
          end
        end,
      }):map("<leader>uv")
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    opts = {
      highlighters = {
        -- Hide passwords
        censor = {
          pattern = "password: ()%S+()",
          group = "",
          extmark_opts = require("util").censor_extmark_opts,
        },
        -- Hex colors
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color({
          style = "inline",
          inline_text = " ",
        }),
      },
    },
  },
}
