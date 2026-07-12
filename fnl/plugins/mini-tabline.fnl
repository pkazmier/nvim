;; ---------------------------------------------------------------------------
;; mini.tabline
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(local tabline (require :mini.tabline))

;; Map of buffer ids that have been "pinned".
(local pinned {})

(fn pinned-format [buf-id label]
  (let [default (tabline.default_format buf-id label)]
    (if (. pinned buf-id) (string.format "%s" default) default)))

(with-now! ; mini.tabline
  (tabline.setup {:format pinned-format}))

(fn toggle-pinned []
  (let [buf-id (vim.api.nvim_get_current_buf)]
    (tset pinned buf-id (not (. pinned buf-id)))
    (vim.cmd :redrawtabline)))

(fn remove-pinned [action force]
  (let [bufremove (require :mini.bufremove)]
    (each [_ buf-id (ipairs (vim.api.nvim_list_bufs))]
      (when (and (. vim.bo buf-id :buflisted) (not (. pinned buf-id)))
        ((. bufremove action) buf-id force)))))

;; Forget a buffer's pinned state when it's removed.
(local autocmds (require :config.autocmds))
(autocmds.new [:BufDelete :BufWipeout]
              {:callback (fn [args] (tset pinned args.buf nil))})

{:toggle_pinned toggle-pinned :remove_pinned remove-pinned}
