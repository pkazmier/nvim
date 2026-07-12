(import-macros {: set-local!} :macros)

(set-local! wrap)
(set-local! spell)

;; Add a blank row below the current one, realign, and drop the cursor (in
;; Insert mode) into its first cell. Insert a bare '|' line: org's parser reads
;; it as a one-cell row joined to the table, so Table:reformat() pads it out to
;; the full column set. col('$') is passed so the table node is found whatever
;; the table's indent (mirrors org's own from_current_node default).
;;
;; org's own Table:handle_cr() (wired to Insert <CR> via org_return) is not
;; enough: it bails when the cursor is at end-of-line -- exactly where one
;; normally presses Enter -- and its cursor placement is racy (feedkeys
;; '<Down>' + a separate vim.schedule with no ordering guarantee). This works
;; from any column and from Normal mode too.
(fn org-table-new-row []
  (local row (vim.fn.line "."))
  (local indent (string.rep " " (vim.fn.indent row)))
  (vim.api.nvim_buf_set_lines 0 row row true [(.. indent "|")])
  (local Table (require :orgmode.files.elements.table))
  (local tbl (Table.from_current_node [row (vim.fn.col "$")]))
  (when tbl (tbl:reformat))
  (local newrow (+ row 1))
  (local line (or (. (vim.api.nvim_buf_get_lines 0 (- newrow 1) newrow true) 1)
                  ""))
  (local bar (line:find "|"))
  (vim.api.nvim_win_set_cursor 0 [newrow (if bar (+ bar 1) 0)])
  (vim.cmd :startinsert))

;; <S-CR> = org's structural Enter, context-aware: in a TABLE row add/realign
;; a row; everywhere else meta_return (add a sibling heading / list item /
;; checkbox, the same method as org's <Leader><CR>).
;;
;; Insert <CR> is org's own org_return (context-aware: tables via
;; Table:handle_cr when mid-row, checkboxes, etc.); for plain lines it falls
;; back to the global mini.keymap <CR> multistep (upstream f32a06d fixed the
;; E15 that fallback used to throw, so the old `org_return = false` workaround
;; is gone). <Tab>/<S-Tab> heading indent lives in fnl/plugins/mini-keymap.fnl
;; (filetype-gated there).
;;
;; Needs a terminal that reports <S-CR> distinctly (kitty keyboard protocol /
;; modifyOtherKeys; Ghostty + Neovim 0.12 do); otherwise it arrives as <CR>.
(fn structural-cr []
  (if (: (vim.api.nvim_get_current_line) :find "^%s*|")
      (org-table-new-row)
      ;; new heading / list item / checkbox
      (let [org (require :orgmode)
            o (org.instance)]
        (o.org_mappings:meta_return))))

(vim.keymap.set [:n :i] :<S-CR> structural-cr
                {:buffer true
                 :desc "Org: structural <CR> (table row / new heading/item)"})
