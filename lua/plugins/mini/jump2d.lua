require("mini.jump2d").setup({
  labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  view = {
    dim = true,
    n_steps_ahead = 2,
  },
})

-- NOTE: <Cr> binding must be set here as jump2d overwrites our mappings.lua.
-- Relies on jump2d opts.mappings.start_jumping being set to <Cr>, so the
-- autocomands to unmap <Cr> in quickfix are installed. I think it would be
-- better if one could just specify the default jump function as an option so
-- one doesn't have to define their own keymap to override it.
vim.keymap.set(
  { "o", "x", "n" },
  "<Cr>",
  "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>",
  { desc = "Jump anywhere" }
)
