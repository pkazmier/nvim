;; ---------------------------------------------------------------------------
;; codecompanion
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; codecompanion
  (local options (require :config.options))
  (when (not options.copilot_disable)
    (vim.pack.add [{:src "https://github.com/nvim-lua/plenary.nvim"}
                   {:src "https://github.com/olimorris/codecompanion.nvim"}])
    (local codecompanion (require :codecompanion))
    (codecompanion.setup {:interactions {:chat {:keymaps {:completion {:modes {:i :<C-/>}
                                                                       :callback :keymaps.completion
                                                                       :description "Completion menu"}}}}})
    ;; -----------------------------------------------------------------------
    ;; Use MiniNotify to track start / stop of requests
    ;; -----------------------------------------------------------------------
    (local notify (require :mini.notify))

    ;; CodeCompanion request ID --> MiniNotify notification ID
    (local ids {})

    (fn format-request-status [ev]
      (let [name (or ev.data.adapter.formatted_name ev.data.adapter.name)
            status ev.data.status
            msg (.. name " " ev.data.interaction " request..." (or status ""))]
        (if (and status (not= status :success))
            (values msg :ERROR :DiagnosticError)
            (values msg :INFO :DiagnosticInfo))))

    (local autocmds (require :config.autocmds))
    (autocmds.new :User
                  {:pattern :CodeCompanionRequestStarted
                   :callback (fn [ev]
                               (local (msg level hl-group) (format-request-status ev))
                               (tset ids ev.data.id (notify.add msg level hl-group)))})
    (autocmds.new :User
                  {:pattern :CodeCompanionRequestFinished
                   :callback (fn [ev]
                               (local (msg level hl-group) (format-request-status ev))
                               (local existing (. ids ev.data.id))
                               (local mini-id (or existing (notify.add msg level hl-group)))
                               (when existing
                                 (tset ids ev.data.id nil)
                                 (notify.update existing {: msg : level :hl_group hl-group}))
                               (vim.defer_fn (fn [] (notify.remove mini-id)) 5000))})))
