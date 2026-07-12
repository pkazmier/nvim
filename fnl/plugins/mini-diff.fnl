;; ---------------------------------------------------------------------------
;; mini.diff
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(fn to-qf []
  (let [diff (require :mini.diff)]
    (vim.fn.setqflist (diff.export :qf))
    (vim.cmd :copen)))

;; `clues` can't live in the table literal: it is produced by the later thunk
;; (gen_hydra_brackets reads mappings that exist only after setup), so the
;; thunk fills it in after the module has already returned this table.
;; mini.clue (queued after us in the manifest) asserts on it.
(local exports {:to_qf to-qf})

(with-later! ; mini.diff
  (local diff (require :mini.diff))
  (diff.setup)
  ;; better mini.diff 'h/H' mapping
  (local functions (require :config.functions))
  (set exports.clues
       (functions.gen_hydra_brackets [:h]
                                     {"[" {:old :first :new :next}
                                      "]" {:old :last :new :prev}})))

exports
