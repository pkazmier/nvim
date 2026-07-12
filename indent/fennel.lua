-- Fennel has no indent file of its own, and Vim's built-in `lisp` mode
-- mishandles Fennel's {} and [] (it aligns their bodies under the bracket
-- instead of under the first element). Borrow Neovim's Clojure indenter,
-- which aligns maps/vectors correctly and shares most of Fennel's form
-- conventions.
--
-- This MUST live in indent/ (not after/ftplugin): Neovim's filetype indent
-- loader sources indent/fennel.lua as its final step, so what we set here
-- survives. Setting `indentexpr` from after/ftplugin runs too early -- the
-- indent loader fires afterwards and runs `b:undo_indent`, wiping it out.
vim.bo.lisp = false
vim.cmd("runtime indent/clojure.vim") -- defines GetClojureIndent(), sets indentexpr
