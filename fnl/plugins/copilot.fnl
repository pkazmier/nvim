;; ---------------------------------------------------------------------------
;; copilot
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; copilot
  (local options (require :config.options))
  (when (not options.copilot_disable)
    (vim.pack.add [{:src "https://github.com/zbirenbaum/copilot.lua"}])
    (local copilot (require :copilot))
    (copilot.setup {:suggestion {:enabled true
                                 :auto_trigger true
                                 :hide_during_completion false}
                    :panel {:enabled false}
                    :filetypes {:markdown true :help true}})))
