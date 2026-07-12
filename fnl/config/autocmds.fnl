;; fnl/config/autocmds.fnl

(local custom_group (vim.api.nvim_create_augroup :my-custom-autocommands {}))

(fn new [event opts]
  (set opts.group (or opts.group custom_group))
  ;; nvim DELETES an autocmd whose callback returns a truthy value, and
  ;; fennel fns implicitly return their last expression -- an innocent tail
  ;; like (pcall ...) or a vim.fn call (-> 0, truthy in lua) silently turns
  ;; a handler into a one-shot. Discard the return; one-shots use :once.
  (when (= (type opts.callback) :function)
    (local cb opts.callback)
    (set opts.callback (fn [ev] (cb ev) nil)))
  (vim.api.nvim_create_autocmd event opts))

;; ---------------------------------------------------------------------------
;; Active Window Cursorline
;; ---------------------------------------------------------------------------
;;
;; Show cursorline only in the current window. I find it annoying to see
;; cursorlines in other windows, so this autocommand will automatically
;; disable when leaving and enable when entering.
(new [:InsertLeave :WinEnter]
     {:callback (fn []
                  (when vim.w.auto_cursorline
                    (set vim.wo.cursorline true)
                    (set vim.w.auto_cursorline nil)))})

(new [:InsertEnter :WinLeave]
     {:callback (fn []
                  (when vim.wo.cursorline
                    (set vim.w.auto_cursorline true)
                    (set vim.wo.cursorline false)))})

{: new}
