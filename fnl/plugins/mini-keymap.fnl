;; ---------------------------------------------------------------------------
;; mini.keymap
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; mini.keymap
  (local keymap (require :mini.keymap))
  (keymap.setup)

  ;; Org <Tab>/<S-Tab> steps: indent / de-indent the heading or list item under
  ;; the cursor in Insert mode (org has no insert mapping for this; demote/promote
  ;; are >> / << in Normal mode). Gated to org headings/list lines so ordinary
  (fn on-org-structure? []
    (when (= vim.bo.filetype :org)
      (let [line (vim.api.nvim_get_current_line)]
        ;; heading (stars in column 0)
        (or (not= (line:find "^%*+%s") nil)
            ;; unordered list (- / +, incl. checkboxes)
            (not= (line:find "^%s*[-+]%s") nil)
            ;; unordered list (indented * bullet)
            (not= (line:find "^%s+%*%s") nil)
            ;; ordered list (1. / 1))
            (not= (line:find "^%s*%d+[.)]%s") nil)))))

  ;; After demote/promote, shift the cursor by the line-length change: org restores
  ;; the ORIGINAL column (winrestview) while the added/removed stars shift the text,
  ;; stranding the cursor among the stars after repeated <Tab>. Capture the cursor
  ;; BEFORE -- promote shortens the line and winrestview clamps a near-end cursor,
  ;; so reading it back would over-shift past the space.
  (fn indent-step [method]
    {:condition on-org-structure?
     :action
     (fn []
       (fn []
         (let [org (require :orgmode)
               instance (org.instance)
               om instance.org_mappings
               [row col] (vim.api.nvim_win_get_cursor 0)
               before (length (vim.api.nvim_get_current_line))]
           ((. om method) om) ; om[method](om)
           (let [delta (- (length (vim.api.nvim_get_current_line)) before)]
             (when (not= delta 0)
               (vim.api.nvim_win_set_cursor 0 [row (math.max 0 (+ col delta))]))))))})

  ;; I really like "jump_after_close" when used with an auto pair plugin. It
  ;; makes it trivial to skip after the closing quote/bracket/brace/paren.
  (keymap.map_multistep :i :<Tab>   [:minisnippets_next (indent-step :do_demote)  :increase_indent :jump_after_close])
  (keymap.map_multistep :i :<S-Tab> [:minisnippets_prev (indent-step :do_promote) :decrease_indent :jump_before_open])

  (keymap.map_multistep :i :<CR> [:pmenu_accept :minipairs_cr])
  (keymap.map_multistep :i :<BS> [:minipairs_bs])

  ;; Better escape key
  (keymap.map_combo [:i :c :x :s :R] :jk :<BS><BS><Esc>)

  ;; Prevent bad habits
  (fn notify-many-keys [key]
    (let [lhs (string.rep key 5)
          action (fn [] (vim.notify (.. "Too many " key)))]
      (keymap.map_combo [:n :x] lhs action)))

  (notify-many-keys :h)
  (notify-many-keys :j)
  (notify-many-keys :k)
  (notify-many-keys :l))
