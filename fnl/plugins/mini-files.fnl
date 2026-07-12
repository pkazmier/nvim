;; ---------------------------------------------------------------------------
;; mini.files
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; Open explorer at the current buffer's directory; bound to <leader>ef.
(fn open-bufdir []
  (let [files (require :mini.files)
        path (when (not= vim.bo.buftype :nofile)
               (vim.api.nvim_buf_get_name 0))]
    (files.open path true)))

;; fnlfmt: skip
(with-later! ; mini.files
  (local files (require :mini.files))
  (files.setup {:windows {:preview true}})
  (local autocmds (require :config.autocmds))
  (autocmds.new
    :User
    {:pattern :MiniFilesExplorerOpen
     :callback (fn []
                 (files.set_bookmark :c (vim.fn.stdpath :config) {:desc :Config})
                 (files.set_bookmark :m (.. (vim.fn.stdpath :data) :/site/pack/core/opt/mini.nvim) {:desc :mini.nvim})
                 (files.set_bookmark :p (.. (vim.fn.stdpath :data) :/site/pack/core/opt) {:desc :Plugins})
                 (files.set_bookmark :w vim.fn.getcwd {:desc "Working directory"}))})

  ;; Create hl namespace to highlight 'mini.files' target window
  (local highlight-ns (vim.api.nvim_create_namespace :highlight_minifiles_target))
  (vim.api.nvim_set_hl highlight-ns :Normal {:link :Visual})
  (vim.api.nvim_set_hl highlight-ns :SignColumn {:link :Visual})

  (fn hl-target-win []
    ;; Only highlight a window if there is more than one possible target
    (local possible-targets
           (accumulate [n 0 _ w (ipairs (vim.api.nvim_tabpage_list_wins 0))]
             (if (= (. (vim.api.nvim_win_get_config w) :relative) "") (+ n 1) n)))
    (when (not= possible-targets 1)
      ;; Temporarily set a hl namespace in target and setup restore
      (local target-win-id (. (files.get_explorer_state) :target_window))
      (local orig-hl-ns (vim.api.nvim_get_hl_ns {:winid target-win-id}))

      (fn restore []
        (vim.api.nvim_win_set_hl_ns target-win-id (if (not= orig-hl-ns -1) orig-hl-ns 0)))

      (vim.api.nvim_win_set_hl_ns target-win-id highlight-ns)
      (autocmds.new :User {:once true
                           :pattern :MiniFilesExplorerClose
                           :callback restore})))

  (autocmds.new :User {:pattern :MiniFilesExplorerOpen
                       :callback hl-target-win
                       :desc "Highlight target window"}))

{:open_bufdir open-bufdir}
