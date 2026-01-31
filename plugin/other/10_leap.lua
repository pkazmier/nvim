-- ---------------------------------------------------------------------------
-- leap
-- ---------------------------------------------------------------------------

-- I prefer the leap over mini.jump2d for the following reasons.
--
--    1. Ability to target blank lines
--    2. Equivalence classes (i.e. single quote matches double quote, backtick)
--    3. Treesitter node selection

Config.later(function()
  vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" })
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
end)
