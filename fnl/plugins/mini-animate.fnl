;; ---------------------------------------------------------------------------
;; mini.animate
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; mini.animate
  (local animate (require :mini.animate))
  (animate.setup 
    {:scroll {:enable false}
     :cursor {:path (animate.gen_path.line
                      ;; Enable animation when moving horizontally within the
                      ;; same line as long as the jump is more than 30 cols. By
                      ;; default, animation is disabled when moving horizontally.
                      {:predicate (fn [dest]
                                    (let [(rows cols) (unpack dest)]
                                      (or (> (math.abs rows) 1)
                                          (> (math.abs cols) 30))))})}}))
