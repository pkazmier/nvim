;; ---------------------------------------------------------------------------
;; mini.bracketed
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; `clues` can't live in a table literal: it is produced by the later thunk
;; (gen_hydra_brackets reads mappings that exist only after setup), so the
;; thunk fills it in after the module has already returned this table.
;; mini.clue (queued after us in the manifest) asserts on it.
(local exports {})

(with-later! ; mini.bracketed
  (local bracketed (require :mini.bracketed))
  (bracketed.setup)
  (local suffixes
         (vim.tbl_map (fn [v] v.suffix) (vim.tbl_values bracketed.config)))
  ;; Better mini.bracketed mappings, see comment in `gen_hydra_brackets`
  ;; definition within `config/functions.fnl`.
  (local functions (require :config.functions))
  (set exports.clues
       (functions.gen_hydra_brackets suffixes
                                     {"[" {:old :first :new :forward}
                                      "]" {:old :last :new :backward}})))

exports
