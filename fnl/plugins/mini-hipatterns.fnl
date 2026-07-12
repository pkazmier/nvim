;; ---------------------------------------------------------------------------
;; mini.hipatterns
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; `match` is a fennel special form, so the parameter needs another name
(fn censor-extmark-opts [_ matched _]
  (let [mask (string.rep :x (vim.fn.strchars matched))]
    {:virt_text [[mask :Comment]]
     :virt_text_pos :overlay
     :priority 2000
     :right_gravity false}))

;; fnlfmt: skip
(with-later! ; mini.hipatterns
  (local hipatterns (require :mini.hipatterns))
  (hipatterns.setup
    {:highlighters
     {;; Hide passwords
      :censor {:pattern "password: ()%S+()" :group "" :extmark_opts censor-extmark-opts}
      ;; Hex colors
      :hex_color (hipatterns.gen_highlighter.hex_color {:style :inline :inline_text " "})
      ;; TODO/FIXME/HACK/NOTE
      :fixme {:pattern "() FIXME():" :group :MiniHipatternsFixme}
      :hack {:pattern "() HACK():" :group :MiniHipatternsHack}
      :todo {:pattern "() TODO():" :group :MiniHipatternsTodo}
      :note {:pattern "() NOTE():" :group :MiniHipatternsNote}
      :fixme_colon {:pattern " FIXME():()" :group :MiniHipatternsFixmeColon}
      :hack_colon {:pattern " HACK():()" :group :MiniHipatternsHackColon}
      :todo_colon {:pattern " TODO():()" :group :MiniHipatternsTodoColon}
      :note_colon {:pattern " NOTE():()" :group :MiniHipatternsNoteColon}
      :fixme_body {:pattern " FIXME:().*()" :group :MiniHipatternsFixmeBody}
      :hack_body {:pattern " HACK:().*()" :group :MiniHipatternsHackBody}
      :todo_body {:pattern " TODO:().*()" :group :MiniHipatternsTodoBody}
      :note_body {:pattern " NOTE:().*()" :group :MiniHipatternsNoteBody}}})
  ;; Highlight patterns for highlighting the whole line and hiding colon.
  ;; See https://github.com/echasnovski/mini.nvim/discussions/783
  ;;
  ;; Setup two additional hl groups to highlight the entire line while
  ;; ensureing a single space is on either side of the keyword as it's
  ;; displayed in reverse. To do this requires MiniHipatternsXXXColon and
  ;; MiniHipatternsXXXBody. We construct them based on the colors of the
  ;; builtin MiniHipatternsXXX.
  (local functions (require :config.functions))

  (fn setup-todo-hl-groups []
    (each [_ keyword (ipairs [:Fixme :Hack :Todo :Note])]
      (let [name (.. :MiniHipatterns keyword)
            info (or (functions.get_hl name) {})
            bg (or info.bg (and info.reverse info.fg))]
        ;; Colon group hides the ":" using same fg and bg
        (vim.api.nvim_set_hl 0 (.. name :Colon) {:fg bg : bg})
        (vim.api.nvim_set_hl 0 (.. name :Body) {:fg bg}))))

  ;; Set the heading todo groups AND an autocmd for colorscheme changes.
  (setup-todo-hl-groups)
  (local autocmds (require :config.autocmds))
  (autocmds.new :Colorscheme
                {:desc "Setup up todo hl groups for mini.hipatterns."
                 :callback setup-todo-hl-groups}))
