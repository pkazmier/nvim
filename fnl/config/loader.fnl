;; fnl/config/loader.fnl

(local misc (require :mini.misc))

(fn now [f] (misc.safely :now f))

(fn later [f] (misc.safely :later f))

;; Decided once at startup: with file/dir args, "now-if-args" thunks run
;; synchronously so editing-critical plugins are ready on first paint.
(local now-if-args (if (> (vim.fn.argc -1) 0) now later))

(fn on-event [ev f] (misc.safely (.. "event:" ev) f))

(fn on-filetype [ft f] (misc.safely (.. "filetype:" ft) f))

(fn on-packchanged [plugin-name kinds callback desc]
  (fn handler [ev]
    (let [name ev.data.spec.name
          kind ev.data.kind]
      (when (and (= name plugin-name) (vim.tbl_contains kinds kind))
        (when (not ev.data.active)
          (vim.cmd.packadd plugin-name))
        (callback))))

  (local autocmds (require :config.autocmds))
  (autocmds.new :PackChanged {:pattern "*" :callback handler : desc}))

{: now
 : later
 :now_if_args now-if-args
 :on_event on-event
 :on_filetype on-filetype
 :on_packchanged on-packchanged}
