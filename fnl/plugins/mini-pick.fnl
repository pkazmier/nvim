;; ---------------------------------------------------------------------------
;; mini.pick
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; Private helpers, defined BELOW the with-later! block so the main logic
;; leads the file. Safe because field access on the pre-bound H is a runtime
;; lookup and the later thunk runs only after the whole module has loaded --
;; a with-now! thunk could NOT reference H fields defined below it.
(local H {})

;; fnlfmt: skip
(with-later! ; mini.pick
  (local pick (require :mini.pick))
  (pick.setup {:source {:preview (fn [buf-id item]
                                   (pick.default_preview buf-id item {:line_position :center}))}
               :window {:prompt_prefix "❯ "}})

  (set vim.ui.select pick.ui_select)

  ;; Config picker
  (set pick.registry.config
       (fn []
         (pick.builtin.files nil {:source {:name "Config Files" :cwd (vim.fn.stdpath :config)}})))

  ;; Buffer picker with modified indicator
  (local modified-ns (vim.api.nvim_create_namespace :kaz-modified-buffer-markers))
  (set pick.registry.buffers
       (fn [local-opts]
         (fn add-modified-marker [buf-id row]
           (vim.api.nvim_buf_set_extmark buf-id modified-ns row 0
                                         {:virt_text [["[+]" :DiagnosticHint]]
                                          :virt_text_pos :eol}))

         (fn show-with-modified-marker [buf-id items query]
           (pick.default_show buf-id items query {:show_icons true})
           (each [i item (ipairs items)]
             (when (. (. vim.bo item.bufnr) :modified)
               (add-modified-marker buf-id (- i 1)))))

         (pick.builtin.buffers local-opts {:source {:show show-with-modified-marker}})))

  ;; Plugin picker
  (local plugin-dir (.. (vim.fn.stdpath :data) :/site/pack/core/opt))
  (set pick.registry.plugins (H.two-stage-dir-picker plugin-dir "Plugin Picker"))

  ;; Project picker
  (set pick.registry.projects (H.two-stage-dir-picker (vim.fn.expand "~/repos") "Repo Picker"))

  ;; Aligned grep picker
  (set pick.registry.grep_align
       (fn [opts]
         (pick.builtin.grep opts {:source {:show H.show-aligned-grep-results}})))

  ;; Aligned live grep picker
  (set pick.registry.grep_live_align
       (fn [opts]
         (pick.builtin.grep_live opts {:source {:show H.show-aligned-grep-results}})))

  ;; Aligned lsp picker
  (set pick.registry.lsp_align
       (fn [opts]
         (let [extra (require :mini.extra)]
           (extra.pickers.lsp opts {:source {:show H.show-aligned-lsp-results}}))))

  ;; Aligned and highlighted TODO picker
  (set pick.registry.grep_todo_keywords
       (fn [opts]
         (set opts.pattern "(TODO|FIXME|HACK|NOTE):")
         (pick.builtin.grep opts
                            {:source {:show (fn [buf-id items query]
                                              (H.show-aligned-grep-results buf-id items query)
                                              (H.highlight-keywords buf-id))}}))))

;; ---------------------------------------------------------------------------
;; Helpers
;; ---------------------------------------------------------------------------

(local sep (package.config:sub 1 1))

(fn H.truncate-path [max-parts]
  (let [max-parts (math.max max-parts 3)]
    (fn [path]
      (let [absolute (= (path:sub 1 1) sep)
            parts (vim.split path sep)
            parts (if absolute (vim.list_slice parts 2 (length parts)) parts)
            n (length parts)
            parts (if (> n max-parts)
                      [(. parts 1) "󰇘" (. parts (- n 1)) (. parts n)]
                      parts)]
        (.. (if absolute sep "") (table.concat parts sep))))))

(fn H.map-gsub [items pattern replacement]
  (vim.tbl_map (fn [item] (pick-values 1 (item:gsub pattern replacement)))
               items))

(fn H.keyword-to-hl-groups [keyword]
  (let [keyword (.. (string.upper (keyword:sub 1 1))
                    (string.lower (keyword:sub 2)))]
    {:keyword (.. :MiniHipatterns keyword)
     :colon (.. :MiniHipatterns keyword :Colon)
     :body (.. :MiniHipatterns keyword :Body)}))

;; items is a table in this shape (NUL byte separators):
;;    {
;;      "what\0we are\0aligning",
;;      "what\0I am\0trying to align",
;;    }
(fn H.show-aligned-grep-results [buf-id items query]
  (let [pick (require :mini.pick)
        align (require :mini.align)
        ;; Shorten the pathname to keep the width of the picker window to
        ;; something a bit more reasonable for longer pathnames.
        items (H.map-gsub items "^%Z+" (H.truncate-path 4))
        ;; Because items is an array of blobs (contains a NUL byte),
        ;; align_strings will not work because it expects strings. So, convert
        ;; the NUL bytes to a unique (hopefully) separator, then align, and
        ;; revert back.
        items (H.map-gsub items "%z" "#|#")
        items (align.align_strings items
                                   {:justify_side [:left :right :right]
                                    :merge_delimiter " "
                                    :split_pattern "#|#"})
        items (H.map-gsub items "#|#" "\000")]
    ;; Back to the regularly scheduled program :-)
    (pick.default_show buf-id items query)))

;; items is a table in this shape ('│' separators):
;;    {
;;      { start = 1, end = 10, path ="blah", text = "what│we are│aligning" },
;;      { start = 1, end = 10, path ="blah", text = "what│I am│trying to align" },
;;    }

;; fnlfmt: skip
(fn H.show-aligned-lsp-results [buf-id items query]
  (let [pick (require :mini.pick)
        align (require :mini.align)
        ;; Shorten the pathname to keep the width of the picker window to
        ;; something a bit more reasonable for longer pathnames.
        item-texts (vim.tbl_map
                     (fn [item] (pick-values 1 (item.text:gsub "^[^│]+" (H.truncate-path 4))))
                     items)
        item-texts (align.align_strings item-texts
                                        {:justify_side [:left :right :right]
                                         :merge_delimiter " "
                                         :split_pattern "│"}
                                        {:pre_justify [(align.gen_step.trim :both :remove)]})]
    (each [i item (ipairs items)]
      (set item.text (. item-texts i)))

    ;; Back to the regularly scheduled program :-)
    (pick.default_show buf-id items query)

    ;; Highlight the lines
    (local ns-id (. (vim.api.nvim_get_namespaces) :MiniExtraPickers))
    (pcall vim.api.nvim_buf_clear_namespace buf-id ns-id 0 -1)
    (each [i item (ipairs items)]
      (vim.api.nvim_buf_set_extmark buf-id ns-id (- i 1) 0
                                    {:end_row i
                                     :end_col 0
                                     :hl_mode :blend
                                     :hl_group item.hl
                                     :priority 199}))))

(fn H.highlight-keywords [bufnr]
  (local ns-id (vim.api.nvim_create_namespace :kaz-keywords))
  (local keywords {})
  (each [_ keyword (ipairs [:TODO :FIXME :HACK :NOTE])]
    (tset keywords (.. " " keyword ":") (H.keyword-to-hl-groups keyword)))
  (local lines (vim.api.nvim_buf_get_lines bufnr 0 -1 false))
  (local extmark-opts {:hl_mode :combine :priority 201})
  (each [row line (ipairs lines)]
    (each [word hl-group (pairs keywords)]
      (let [(start-idx end-idx) (line:find word)]
        (when (and start-idx end-idx)
          ;; Highlights the keyword
          (set extmark-opts.hl_group hl-group.keyword)
          (set extmark-opts.end_row (- row 1))
          (set extmark-opts.end_col (- end-idx 1))
          (vim.api.nvim_buf_set_extmark bufnr ns-id (- row 1) (- start-idx 1)
                                        extmark-opts)
          ;; Highlights the ':'
          (set extmark-opts.hl_group hl-group.colon)
          (set extmark-opts.end_col end-idx)
          (vim.api.nvim_buf_set_extmark bufnr ns-id (- row 1) (- end-idx 1)
                                        extmark-opts)
          ;; Highlights the rest of the line
          (set extmark-opts.hl_group hl-group.body)
          (set extmark-opts.end_col (length line))
          (vim.api.nvim_buf_set_extmark bufnr ns-id (- row 1) end-idx
                                        extmark-opts))))))

;; Creates a two-stage directory picker. First stage picks a directory inside
;; `dir` with the explorer, then the second stage opens a file picker inside
;; the chosen directory.

;; fnlfmt: skip
(fn H.two-stage-dir-picker [dir name]
  (fn pred [item] (not= item.text ".."))

  (fn choose [item]
    (vim.schedule (fn []
                    (let [pick (require :mini.pick)]
                      (pick.builtin.files nil {:source {:name item.text :cwd item.path}})))))

  (fn []
    (let [extra (require :mini.extra)]
      (extra.pickers.explorer {:cwd dir :filter pred} {:source {: name : choose}}))))
