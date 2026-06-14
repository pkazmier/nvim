-- Buffer-local overrides for org files. This runs AFTER orgmode's own
-- ftplugin/org.lua (the `after/` dir is last on 'runtimepath'), so org's
-- buffer-local mappings -- set synchronously there via config:setup_mappings --
-- are already in place and we can override them directly, no autocmd/scheduling.

-- Replace org's buffer-local Insert <CR> (org_return) with a mini.keymap
-- multistep { pmenu_accept, minipairs_cr }. Why a replacement is needed: on any
-- line org itself does not handle, org_return falls back by looking up the GLOBAL
-- mini.keymap <CR> and `vim.eval`-ing its result -- but mini.keymap is an
-- expression map returning a keycode string ("<CR>"), and eval-ing that throws
-- "E15: Invalid expression" (an upstream org bug: it should feed a Lua-callback
-- expr map's return, not eval it). Pre-empting org_return here avoids that.
--
-- We intentionally keep ALL org "structural Enter" off <CR> and on <S-CR>: both
-- adding a heading/item/checkbox AND realigning/extending a table live there. So
-- <CR> stays dead simple -- accept a mini.completion popup item, else a pair-aware
-- newline -- and the global <CR> multistep is untouched for every other buffer.
--
-- NOTE: require() the function rather than the global MiniKeymap. This ftplugin
-- can run during a cold-start `nvim file.org` BEFORE mini.keymap's deferred
-- setup() assigns _G.MiniKeymap, so the global would be nil here; require works
-- immediately (mini.nvim is eagerly added) and map_multistep needs no setup().
require("mini.keymap").map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" }, { buffer = true })

-- <S-CR> = org's structural Enter, context-aware: inside a TABLE row hand off to
-- org_return (realign / add a row -- it handles tables in its first action and
-- returns before the broken eval fallback); everywhere else meta_return (add a
-- sibling heading / list item / checkbox, the same method as org's <Leader><CR>).
-- This keeps <CR> simple and replaces the intrusive "every <CR> makes a heading"
-- of org_return_uses_meta_return. Needs a terminal that reports <S-CR> distinctly
-- (kitty keyboard protocol / modifyOtherKeys; Ghostty + Neovim 0.12 do);
-- otherwise it arrives as <CR>.
vim.keymap.set("i", "<S-CR>", function()
  local org_mappings = require("orgmode").instance().org_mappings
  if vim.api.nvim_get_current_line():find("^%s*|") then
    org_mappings:org_return() -- table row: realign / add row
  else
    org_mappings:meta_return() -- new heading / list item / checkbox
  end
end, { buffer = true, desc = "Org: structural <CR> (table row / new heading/item)" })
