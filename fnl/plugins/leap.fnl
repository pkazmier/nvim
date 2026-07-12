;; ---------------------------------------------------------------------------
;; leap
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; I prefer the leap over mini.jump2d for the following reasons.
;;
;;    1. Ability to target blank lines
;;    2. Equivalence classes (i.e. single quote matches double quote, backtick)
;;    3. Treesitter node selection

(with-later! ; leap
  (vim.pack.add [{:src "https://codeberg.org/andyg/leap.nvim"}])
  (local leap (require :leap))
  (set leap.opts.equivalence_classes [" \t\r\n" "([{" ")]}" "'\"`"]))
