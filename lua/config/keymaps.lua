-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- I could not live without this binding.
vim.keymap.set("i", "jk", "<esc>", { silent = true })

-- From mini.basics
-- stylua: ignore start
vim.keymap.set("c", "<M-h>", "<Left>",  { silent = false,  desc = "Left" })
vim.keymap.set("c", "<M-l>", "<Right>", { silent = false,  desc = "Right" })
vim.keymap.set("i", "<M-h>", "<Left>",  { noremap = false, desc = "Left" })
vim.keymap.set("i", "<M-j>", "<Down>",  { noremap = false, desc = "Down" })
vim.keymap.set("i", "<M-k>", "<Up>",    { noremap = false, desc = "Up" })
vim.keymap.set("i", "<M-l>", "<Right>", { noremap = false, desc = "Right" })
vim.keymap.set("t", "<M-h>", "<Left>",  { desc = "Left" })
vim.keymap.set("t", "<M-j>", "<Down>",  { desc = "Down" })
vim.keymap.set("t", "<M-k>", "<Up>",    { desc = "Up" })
vim.keymap.set("t", "<M-l>", "<Right>", { desc = "Right" })
-- stylua: ignore end
