;; ---------------------------------------------------------------------------
;; mini.starter
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(local banner "
                  █                █

████████████  ███  ████████  ███
██████████████  ████  ██████████  ████
█████ ████ █████  ████  █████ █████  ████
█████ ████ █████ ███  █████ █████ ███
")

;; (local banner "
;; │ ╲ ││  ╲    ╱  ││   │ ╲  ╱ │
;; ││╲╲││   ╲╲╱╱   ││   ││╲╲╱╱││
;; ││ ╲ │    ╲╱    ││   ││ ╲╱ ││
;; ")

;; fnlfmt: skip
(with-now! ; mini.starter
  (local starter (require :mini.starter))

  (fn fortune []
    (let [cmd "fortune -s | fmt 38"
          (ok result) (pcall (fn []
                               (let [f (assert (io.popen cmd :r))
                                     s (assert (f:read :*a))]
                                 (f:close)
                                 s)))]
      (when ok result)))

  (starter.setup {:items [(starter.sections.sessions 3 true)
                          (starter.sections.recent_files 3 false false)
                          [{:name "Mason"          :action :Mason                  :section :Actions}
                           {:name "Update plugins" :action "lua vim.pack.update()" :section :Actions}
                           {:name "Visited files"  :action "Pick visit_paths"      :section :Actions}
                           {:name "Quit Neovim"    :action :qall                   :section :Actions}]]
                  :header banner
                  :footer fortune
                  }))
