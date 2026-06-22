vim.opt_local.wrap = true
vim.opt_local.spell = true

-- <S-CR> = org's structural Enter, context-aware: in a TABLE row add/realign a
-- row; everywhere else meta_return (add a sibling heading / list item / checkbox,
-- the same method as org's <Leader><CR>).
--
-- org's own Insert <CR> (org_return) is DISABLED in org.setup, so the global
-- <CR> multistep applies here -- no buffer-local <CR> needed. <Tab>/<S-Tab>
-- heading indent lives in plugin/mini/10_mini.keymap.lua (filetype-gated there).
--
-- Needs a terminal that reports <S-CR> distinctly (kitty keyboard protocol /
-- modifyOtherKeys; Ghostty + Neovim 0.12 do); otherwise it arrives as <CR>.
vim.keymap.set({ "n", "i" }, "<S-CR>", function()
  if vim.api.nvim_get_current_line():find("^%s*|") then
    -- Table row: add a new row and land in its first cell. We do NOT use org's
    -- own Table:handle_cr() -- its cursor placement is racy (see the TABLE
    -- EDITING note in plugin/other/10_orgmode.lua) and it bails at end-of-line.
    Config.org_table_new_row()
  else
    require("orgmode").instance().org_mappings:meta_return() -- new heading / list item / checkbox
  end
end, { buffer = true, desc = "Org: structural <CR> (table row / new heading/item)" })
