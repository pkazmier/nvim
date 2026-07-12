;; ---------------------------------------------------------------------------
;; mini.operators
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; mini.operators
  (local functions (require :config.functions))
  (functions.remap :n :gx :gX)
  (functions.remap :x :gx :gX)
  (local clue (require :mini.clue))
  (clue.set_mapping_desc :n :gX "Open file or URI")
  (clue.set_mapping_desc :x :gX "Open file or URI")
  ;; From https://github.com/echasnovski/mini.nvim/discussions/1835
  (var comment-multiply false)

  (fn my-multiply-func [content]
    (if (not (and comment-multiply (= content.submode :V)))
        content.lines
        (do
          ;; Add comment
          (set comment-multiply false)
          (local commentstring vim.bo.commentstring)
          (vim.tbl_map (fn [l]
                         (pick-values 1 (commentstring:gsub "%%s" l)))
                       content.lines))))

  (local operators (require :mini.operators))
  (operators.setup {:multiply {:func my-multiply-func}})

  (fn map-comment-multiply [mode lhs multiply-keys desc]
    (fn rhs []
      ;; Preserve cursor position so that it is on *not* commented part
      (local pos (vim.api.nvim_win_get_cursor 0))
      (vim.schedule (fn [] (vim.api.nvim_win_set_cursor 0 pos)))
      (set comment-multiply true)
      multiply-keys)

    (vim.keymap.set mode lhs rhs {:expr true :remap true : desc}))

  (map-comment-multiply [:n :x] :gC :gm "Multiply and comment")
  (map-comment-multiply :n :gCC :gmm "Multiply and comment line"))
