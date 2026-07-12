;; ---------------------------------------------------------------------------
;; orgmode
;; ---------------------------------------------------------------------------
(import-macros {: with-now!} :macros)

(with-now! ; orgmode
  (vim.pack.add [{:src "https://github.com/nvim-orgmode/orgmode"}
                 {:src "https://github.com/nvim-orgmode/org-bullets.nvim"}])
  ;; nvim-orgmode configuration -- TAG model, dynamic meeting views
  ;;
  ;; Tag conventions:
  ;;   <name>  -> a recurring meeting, identified by FILETAGS of
  ;;             ~/org/meetings/<name>.org. A 1:1 is just a meeting whose name is
  ;;             a person; tag that name on an item anywhere (e.g. a task you owe
  ;;             someone, raised in another meeting) to surface it in their view.
  ;;
  ;; FILETAGS carry IDENTITY ONLY. So:
  ;;   #+FILETAGS: alice         (alice's 1:1 file)
  ;;   #+FILETAGS: staff         (staff meeting file)
  ;; Items you record then take a TODO state (the "discuss vs do" axis is the
  ;; STATE itself, not a tag):
  ;;   * AGND ...        a topic to RAISE  -> "Discuss" + that meeting's view
  ;;   * NEXT/TODO ...   your action       -> "Do now" + that meeting's view
  ;;   * WAIT ...        delegated         -> "Waiting" + that meeting's view
  ;; AGND is its own keyword (a discussion point is a distinct thing, never also a
  ;; tracked action); the custom agenda views give it its own block, so it no
  ;; longer needs to be first in org_todo_keywords to surface. Add a
  ;; keyworded item with <S-CR> (new heading) then a snippet from snippets/org.json:
  ;; type t/a/w + <C-j> for TODO/AGND/WAIT.
  (local org (require :orgmode))
  (local functions (require :config.functions))
  ;; Todo-keyword colors derived from the CURRENT theme's Diagnostic groups, so
  ;; they track colorscheme switches. Recomputed (and re-applied) on ColorScheme
  ;; via setup-org-hl-groups below.

  (fn org-todo-faces []
    (fn fg [group]
      (string.format "#%06x" (. (functions.get_hl group) :fg)))

    {:AGND (.. ":weight bold :foreground " (fg :DiagnosticInfo))
     :NEXT (.. ":weight bold :foreground " (fg :DiagnosticError))
     :TODO (.. ":weight bold :foreground " (fg :DiagnosticWarn))
     :WAIT (.. ":weight bold :foreground " (fg :DiagnosticHint))
     :DONE (.. ":weight bold :foreground " (fg :DiagnosticUnnecessary))
     :CNCL (.. ":weight bold :foreground " (fg :DiagnosticUnnecessary))})

  (org.setup {:org_agenda_files ["~/org/**/*"]
              :org_default_notes_file "~/org/tasks.org"
              ;; Start week on Sunday in calendar widget and agenda time grid views.
              :calendar_week_start_day 0
              :org_agenda_start_on_weekday 0
              :org_agenda_block_separator ""
              :win_split_mode :auto
              ;; 4-char keywords for consistent-width badges. List order no longer drives
              ;; retrieval: the custom agenda views now split each state into its own
              ;; block, so the old 'todo-state-up' float (which needed AGND first) is moot.
              ;; Order now only sets the fast-access menu order; TODO leads as the everyday
              ;; default, AGND trails as the odd-one-out (a discussion point, never a
              ;; tracked action). Reset target for repeating tasks is pinned explicitly
              ;; below (org_todo_repeat_to_state), NOT inferred from this order.
              :org_todo_keywords ["TODO(t)"
                                  "NEXT(n)"
                                  "WAIT(w)"
                                  "AGND(a)"
                                  "|"
                                  "DONE(d)"
                                  "CNCL(c)"]
              :org_todo_keyword_faces (org-todo-faces)
              ;; When a repeating task (SCHEDULED/DEADLINE with a +N repeater) is marked
              ;; DONE, org advances the date and resets the keyword. WITHOUT this, it resets
              ;; to the first TODO-type keyword in the list (see TodoState:get_reset_todo) --
              ;; which would land on whatever leads org_todo_keywords. Pin it to TODO so a
              ;; recurrence comes back for re-triage in planning, never auto-promoted to
              ;; NEXT and never (the old bug) flipped to AGND.
              :org_todo_repeat_to_state :TODO
              :org_deadline_warning_days 7
              :org_log_into_drawer :LOGBOOK
              :org_blank_before_new_entry {:heading false
                                           :plain_list_item false}
              ;; org_use_tag_inheritance = true  -- default; filetags flow to headlines
              ;;
              ;; Heading aesthetics (native, no plugin):
              :org_hide_leading_stars false
              ;; virtual-indent content under its heading
              :org_startup_indented true
              ;; nicer fold marker than '...'
              :org_ellipsis " ⤵"
              ;; hide the * / / _ around bold/italic
              :org_hide_emphasis_markers true
              ;; Tag alignment, applied when org aligns tags (e.g. <leader>ot / set-tags):
              ;; NEGATIVE = right-align so tags END at column |value| (default -80).
              ;; POSITIVE = tags START at that absolute column.
              ;; Lower the magnitude to pull tags closer to the title (e.g. -60).
              :org_tags_column 0
              ;; Quick-capture for when you're NOT already typing in a meeting file.
              ;; Lands in tasks.org and stays there -- no refiling. Location is irrelevant
              ;; to retrieval; the agenda finds it by TODO state + tags wherever it lives.
              ;; If a capture belongs to a person/meeting, add that tag in the capture
              ;; buffer with <leader>ot before finalizing (that's tagging, not refiling).
              :org_capture_templates {;; No %a backlink: nvim-orgmode's %a is a bare [[file:PATH::LINE]] (line
                                      ;; number only, no headline/ID search), which rots immediately in our
                                      ;; newest-at-top meeting files. Retrieval here is positional-independent
                                      ;; anyway -- found by TODO state + tags wherever the item lives -- so the
                                      ;; durable pointer is a tag (add one with <leader>ot), not a file::line.
                                      :t {:description :Task
                                          :template "* TODO %?"
                                          :target "~/org/tasks.org"
                                          :headline :Tasks}
                                      ;; Agenda item. Add the meeting/person tag in the capture buffer with
                                      ;; <leader>ot (native org_set_tags, which completes against the live tag
                                      ;; list) before finalizing. Top-level -- found by AGND + tag anywhere.
                                      :a {:description "Agenda item"
                                          :template "* AGND %?"
                                          :target "~/org/tasks.org"
                                          :headline :Tasks}
                                      ;; Scheduled / recurring task: a dated TODO. %^t opens the calendar widget;
                                      ;; for a recurring task, add a repeater (e.g. +1w / +1m) inside the <> in the
                                      ;; capture buffer before finalizing. (One template covers both.)
                                      :s {:description "Scheduled task"
                                          :template "* TODO %?\nSCHEDULED: %^t"
                                          :target "~/org/tasks.org"
                                          :headline :Tasks}
                                      ;; Deadline task: due-by date. Shows with a lead-in warning in the agenda
                                      ;; (org_deadline_warning_days) and in the weekly review (r).
                                      :d {:description "Deadline task"
                                          :template "* TODO %?\nDEADLINE: %^t"
                                          :target "~/org/tasks.org"
                                          :headline :Tasks}
                                      ;; Calendar event: a birthday / anniversary / holiday. A plain heading (NO
                                      ;; todo keyword) with the active timestamp ON the heading line; %^t picks the
                                      ;; date, add +1y in the buffer for the usual yearly recurrence. No tag needed.
                                      ;; These collect under "* Events" in calendar.org -- open that file to view
                                      ;; them (also surfaced in the agenda time grid when within its span).
                                      :c {:description "Calendar event"
                                          :template "* %? %^t"
                                          :target "~/org/calendar.org"
                                          :headline :Events}}
              :org_agenda_custom_commands {;; DAILY LIST VIEW: This is the view I use throughout the day after I've
                                           ;; identified the NEXT items from my planning view.
                                           :d {:description "Daily list"
                                               :types [{:type :agenda
                                                        :org_agenda_span :day
                                                        :org_agenda_overriding_header :Today}
                                                       {:type :tags_todo
                                                        :match :/NEXT
                                                        :org_agenda_todo_ignore_deadlines :far
                                                        :org_agenda_todo_ignore_scheduled :past
                                                        :org_agenda_overriding_header "Do now"}]}
                                           ;; DAILY PLANNING VIEW: I use this every morning to identify the tasks
                                           ;; I want to do today by changing them from TODO to NEXT.
                                           :p {:description "Daily planning"
                                               :types [{:type :agenda
                                                        :org_agenda_span :week
                                                        :org_agenda_overriding_header :Week}
                                                       {:type :tags_todo
                                                        :match :/NEXT
                                                        :org_agenda_todo_ignore_deadlines :far
                                                        :org_agenda_todo_ignore_scheduled :past
                                                        :org_agenda_overriding_header "Do now"}
                                                       {:type :tags_todo
                                                        :match :/TODO
                                                        :org_agenda_todo_ignore_deadlines :far
                                                        :org_agenda_todo_ignore_scheduled :past
                                                        :org_agenda_overriding_header "Do later"}]}
                                           ;; WEEKLY REVIEW: I use this every week to review everything including
                                           ;; WAIT and AGND task.
                                           :r {:description "Weekly review"
                                               :types [{:type :agenda
                                                        :org_agenda_span 14
                                                        :org_agenda_overriding_header "Next 2 weeks"}
                                                       {:type :tags_todo
                                                        :match :/NEXT
                                                        :org_agenda_todo_ignore_deadlines :far
                                                        :org_agenda_todo_ignore_scheduled :past
                                                        :org_agenda_overriding_header "Do now"}
                                                       {:type :tags_todo
                                                        :match :/TODO
                                                        :org_agenda_todo_ignore_deadlines :far
                                                        :org_agenda_todo_ignore_scheduled :past
                                                        :org_agenda_overriding_header "Do later"}
                                                       {:type :tags_todo
                                                        :match :/WAIT
                                                        :org_agenda_overriding_header "Waiting / delegated"
                                                        :org_agenda_sorting_strategy [:tag-up
                                                                                      :priority-down]}
                                                       {:type :tags_todo
                                                        :match :/AGND
                                                        :org_agenda_overriding_header :Discuss
                                                        :org_agenda_sorting_strategy [:tag-up
                                                                                      :priority-down]}]}
                                           ;; MEETING VIEW: every open item split into the three states, with NO date
                                           ;; filtering so the whole backlog sits in the buffer. Press / in the agenda
                                           ;; to filter by a person/meeting tag -- completion is over the tags actually
                                           ;; present in the buffer (case-sensitive). Replaces the old <leader>oM
                                           ;; MiniPick picker: same three sections, but pure built-in. Open via the
                                           ;; agenda menu (<leader>oa -> v), then / to filter. Priority-sorted within
                                           ;; each section.
                                           :v {:description "Meeting view"
                                               :types [{:type :tags_todo
                                                        :match :/AGND
                                                        :org_agenda_sorting_strategy [:priority-down]
                                                        :org_agenda_overriding_header :Discuss}
                                                       {:type :tags_todo
                                                        :match :/NEXT|TODO
                                                        :org_agenda_sorting_strategy [:priority-down]
                                                        :org_agenda_overriding_header "To do"}
                                                       {:type :tags_todo
                                                        :match :/WAIT
                                                        :org_agenda_sorting_strategy [:priority-down]
                                                        :org_agenda_overriding_header "Waiting / delegated"}]}}})

  (fn setup-org-hl-groups []
    (vim.api.nvim_set_hl 0 "@org.agenda.day" {:link :Question})
    (vim.api.nvim_set_hl 0 "@org.agenda.today" {:link :CursorLineNr})
    (vim.api.nvim_set_hl 0 "@org.agenda.scheduled" {:link :SpecialComment})
    (vim.api.nvim_set_hl 0 "@org.agenda.weekend.today" {:link :CursorLineNr})
    (vim.api.nvim_set_hl 0 "@org.agenda.header" {:link :MiniStarterSection})
    (vim.api.nvim_set_hl 0 "@org.agenda.tag" {:link :Special})
    ;; Refresh the todo-keyword faces from the new theme. org reads them from its
    ;; config, so push fresh values with config:extend. Then re-apply -- but org
    ;; applies faces with `hi default` (won't override a set group) AND its own
    ;; ColorScheme handler re-defines them first, so clear the @org.keyword.face.*
    ;; groups before re-defining or the old colors stick.
    (local cfg (require :orgmode.config))
    (cfg:extend {:org_todo_keyword_faces (org-todo-faces)})
    (each [keyword (pairs cfg.org_todo_keyword_faces)]
      (vim.cmd (.. "highlight clear @org.keyword.face." (keyword:gsub "%-" ""))))
    (local highlights (require :orgmode.colors.highlights))
    (highlights.define_todo_keyword_faces))

  (setup-org-hl-groups)
  (local autocmds (require :config.autocmds))
  (autocmds.new :ColorScheme
                {:desc "Tune the agenda tag hl group to point to Special."
                 :callback setup-org-hl-groups})
  ;; ---------------------------------------------------------------------------
  ;; ICON HEADING BULLETS (nvim-orgmode/org-bullets.nvim). Replaces the visible
  ;; star with a per-level icon. Combined with the native org_hide_leading_stars
  ;; + org_startup_indented above, headings render as a single indented icon.
  (local bullets (require :org-bullets))
  (bullets.setup {;; keep the icon (not the raw stars) on the cursor line
                  :concealcursor true
                  :symbols {;; one per heading level (cycles): * Meetings, ** date, *** note, ...
                            :headlines ["◉" "○" "✸" "✿" "✤" "✜"]
                            :list "•"
                            :checkboxes {:half ["" "@org.checkbox.halfchecked"]
                                         :done ["✓" "@org.keyword.done"]
                                         :todo ["˟" "@org.keyword.todo"]}}}))

;; ---------------------------------------------------------------------------
;; CUSTOM ORG COMMANDS. Exported below and mapped globally in
;; fnl/config/keymaps.fnl under <leader>o. They work from any buffer; the
;; keys chosen there avoid the <leader>o<key> sequences org claims in org files
;; (e.g. org's buffer-local <leader>oe export -- hence new meeting entry is om).
;; ---------------------------------------------------------------------------

(local ORG-ROOT (.. (vim.fn.expand "~/org") "/"))

(fn org-rel [p]
  (pick-values 1 (p:gsub (.. "^" (vim.pesc ORG-ROOT)) "")))

;; ---------------------------------------------------------------------------
;; OPEN ANY ORG FILE FROM ANYWHERE (MiniPick). builtin.files takes no glob
;; filter, so drive ripgrep through builtin.cli: --glob '*.org' lists only org
;; files (excluding *.org_archive, a different extension). The postprocess turns
;; each rg path into a pretty item -- basename without .org, underscores to
;; spaces (meetings/pete_kazmier.org -> "pete kazmier") -- so item.text is what's
;; SHOWN and matched, while item.path (absolute) drives default open/preview.

;; fnlfmt: skip
(fn files []
  (let [pick (require :mini.pick)]
    (pick.builtin.cli {:command [:rg :--files :--glob :*.org :--color=never]
                       :postprocess (fn [paths]
                                      (local items [])
                                      (each [_ p (ipairs paths)]
                                        (when (not= p "")
                                          (let [name (: (vim.fn.fnamemodify p ":t:r") :gsub "_" " ")]
                                            (table.insert items {:text name :path (.. ORG-ROOT p)}))))
                                      items)}
                      {:source {:name "Org files" :cwd ORG-ROOT}})))

;; ---------------------------------------------------------------------------
;; SEARCH ALL HEADLINES (MiniPick). Jump to any heading across every file.
;; Items carry path + lnum, so default choose jumps and preview shows context.
(fn headlines []
  (let [org (require :orgmode)
        o (org.instance)
        items []]
    ;; idempotent
    (o.files:load)
    (each [_ file (ipairs (o.files:all))]
      (local short (org-rel file.filename))
      (each [_ h (ipairs (file:get_headlines))]
        (table.insert items
                      {:text (string.format "%s  %s" short (h:get_title))
                       :path file.filename
                       :lnum (. (h:get_range) :start_line)})))
    (when (not (vim.tbl_isempty items))
      (let [pick (require :mini.pick)]
        (pick.start {:source {:name "Org headlines" : items}})))))

;; ---------------------------------------------------------------------------
;; SEARCH ALL LINES (MiniPick live grep over ~/org, full text not just
;; headlines). Needs ripgrep, which mini.pick's grep uses.
(fn grep []
  (let [pick (require :mini.pick)]
    (pick.builtin.grep_live {} {:source {:cwd ORG-ROOT}})))

;; Tag vocabulary, top of e.g. ~/org/tasks.org:
;;   #+TAGS: alice bob staff eng_sync project_x

;; ---------------------------------------------------------------------------
;; FILE LAYOUT (convention)
;;   ~/org/tasks.org            personal tasks (scheduled, recurring, captured)
;;   ~/org/meetings/<name>.org  one per recurring meeting -- a person's 1:1 or a
;;                              forum -- with #+FILETAGS: <name>
;;   ~/org/adhoc.org            ad-hoc meetings   (tag the date heading :who:)
;;   ~/org/projects/<name>.org  project notes/tasks
;;
;; No inbox, no refiling: the agenda scans the whole tree and organizes by
;; TODO state + tags, so a task is found wherever it lives. Type items right
;; in the meeting file -- they inherit its identity tag, so your actions go to
;; "Do now", delegations to "Waiting", both still showing in that meeting's
;; view. Add :agenda: by hand only to a genuine thing-to-raise.
;; ---------------------------------------------------------------------------

;; Open `path`, add today's dated entry as the first child of the top-level
;; "* Meetings" heading (creating that heading if absent), newest first, and
;; enter insert mode at the END of the date heading -- from there press <CR>/
;; <S-CR> for notes, or SPC + a name for an ad-hoc meeting.
(fn start-entry [path]
  (vim.cmd (.. "edit " (vim.fn.fnameescape path)))
  (local lines (vim.api.nvim_buf_get_lines 0 0 -1 false))
  (local date-line (.. "** " (os.date "%Y-%m-%d %a")))
  ;; locate the "* Meetings" top-level heading (with or without trailing tags)
  (var meetings-at nil)
  (each [i line (ipairs lines) &until meetings-at]
    (when (or (line:match "^%*%s+Meetings%s*$")
              (line:match "^%*%s+Meetings%s+:"))
      (set meetings-at i)))
  (var insert-at nil)
  (var new-lines nil)
  (if meetings-at
      (do
        (set insert-at meetings-at)
        (set new-lines [date-line]))
      (do
        ;; no Meetings heading yet: create it after the leading #+directives
        (set insert-at 0)
        (var stop false)
        (each [i line (ipairs lines) &until stop]
          (if (or (line:match "^%s*#%+") (line:match "^%s*$"))
              (set insert-at i)
              (set stop true)))
        (set new-lines ["* Meetings" date-line])))
  (vim.api.nvim_buf_set_lines 0 insert-at insert-at false new-lines)
  ;; cursor on the date heading (last inserted line); startinsert! -> end of line
  (vim.api.nvim_win_set_cursor 0 [(+ insert-at (length new-lines)) 0])
  (vim.cmd :startinsert!))

;; All recurring-meeting logs live in one folder; identity is just the file's
;; name (no person/forum distinction, no sigil).
(local MEETINGS-DIR (vim.fn.expand "~/org/meetings"))

;; Scaffold a brand-new meeting log (#+FILETAGS: <name>), then start its entry.
;; #+CATEGORY: meeting makes the agenda's left column read "meeting" (a type) for
;; every item here, instead of the filename -- the specific meeting is still shown
;; by its filetag.
(fn new-log []
  (vim.ui.input {:prompt "Meeting name: "}
                (fn [name]
                  (when (and name (not= (vim.trim name) ""))
                    (local slug
                           (-> (vim.trim name)
                               (: :gsub "%s+" "_")
                               (: :gsub "[^%w_]" "")))
                    (if (= slug "")
                        (vim.notify "Invalid name" vim.log.levels.WARN)
                        (do
                          (vim.fn.mkdir MEETINGS-DIR :p)
                          (local path (.. MEETINGS-DIR "/" slug :.org))
                          (when (= (vim.fn.filereadable path) 0)
                            (vim.fn.writefile [(.. "#+TITLE: " name)
                                               "#+CATEGORY: meeting"
                                               (.. "#+FILETAGS: :" slug ":")
                                               ""
                                               "* Meetings"]
                                              path))
                          ;; register with the running instance so it appears in
                          ;; the pickers/agenda immediately, without a restart or
                          ;; reload
                          (let [org (require :orgmode)
                                o (org.instance)]
                            (o.files:add_to_paths path))
                          (start-entry path)))))))

;; NEW MEETING ENTRY: pick an existing meeting log -- or create one -- then
;; insert today's dated heading and start typing at once.
(fn new-meeting-entry []
  ;; "New..." first
  (local items [{:text "＋ New meeting log" :is_new true}])
  ;; vim.fs.dir is silent on a missing dir (unlike vim.fn.readdir, which prints
  ;; "E484: Can't open file"), so MEETINGS-DIR not existing yet is a harmless
  ;; no-op -- no guard needed. Filter by name only (not the yielded type) to
  ;; stay symlink-tolerant: a symlinked log reports type "link", not "file".
  (each [name (vim.fs.dir MEETINGS-DIR)]
    (when (name:match "%.org$")
      (let [p (.. MEETINGS-DIR "/" name)]
        (table.insert items {:text (vim.fn.fnamemodify p ":t:r") :path p}))))
  (local adhoc (vim.fn.expand "~/org/adhoc.org"))
  (when (= (vim.fn.filereadable adhoc) 1)
    (table.insert items {:text "Ad Hoc meeting" :path adhoc}))

  (fn choose [item]
    (when item
      (vim.schedule (fn []
                      (if item.is_new
                          (new-log)
                          (start-entry item.path))))))

  (let [pick (require :mini.pick)]
    (pick.start {:source {:name "New meeting entry" : items : choose}})))

;; NOTE: org buffer-local mappings (<leader>it, <CR>, <S-CR>) live in
;; after/ftplugin/org.lua, which runs after orgmode's own ftplugin so it can
;; override org's buffer-local mappings without an autocmd or scheduling.

{: files : headlines : grep :new_meeting_entry new-meeting-entry}
