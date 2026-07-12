;; ---------------------------------------------------------------------------
;; mini.visits
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(fn pick [cwd label]
  (let [visits (require :mini.visits)
        extra (require :mini.extra)
        sort-latest (visits.gen_sort.default {:recency_weight 1})
        name (.. "Visit " label " (" (if cwd :all :cwd) ")")
        local-opts {: cwd :filter label :sort sort-latest}]
    (extra.pickers.visit_paths local-opts {:source {: name}})))

(with-later! ; mini.visits
  (local visits (require :mini.visits))
  (visits.setup))

{: pick}
