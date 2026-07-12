;; fnl/config/keymaps.fnl
(import-macros {: set! : with-later!} :macros)

;; ---------------------------------------------------------------------------
;; Helpers
;; ---------------------------------------------------------------------------

(fn map [mode lhs rhs desc opts]
  (let [opts (or opts {})]
    (set opts.desc desc)
    (vim.keymap.set (vim.split mode "") lhs rhs opts)))

(fn ldr [key] (.. :<leader> key))
(fn cmd [cmd] (.. :<Cmd> cmd :<CR>))
(fn ext [plugin func] (cmd (.. "lua require('" plugin "')." func)))

;; ---------------------------------------------------------------------------
;; Leader Groups
;; ---------------------------------------------------------------------------

;; Leader mappings and descriptions, exported at the bottom of this module
;; for mini.clue's setup (plugins/mini-clue.fnl requires us).

;; fnlfmt: skip
(local leader-group-clues
       (let [clues [[:n  :b :+Buffer]
                    [:nx :c :+Copilot]
                    [:n  :e :+Explore]
                    [:n  :f :+Find]
                    [:nx :g :+Git]
                    [:nx :l :+Language]
                    [:n  :m :+Map]
                    [:n  :o :+Org]
                    [:n  :O :+Other]
                    [:n  :s :+Session]
                    [:n  :v :+Visits]
                    [:n  :w :+Window]]]
         (icollect [_ [mode keys desc] (ipairs clues)]
           {:mode (vim.split mode "") :keys (ldr keys) : desc})))

;; ---------------------------------------------------------------------------
;; Basic Mappings
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :i    "<A-Space>"  (cmd "normal ciw")                           "Just one space")
  (map :n    "-"          (cmd :Oil)                                   "Open Oil")
  (map :n    :H           (cmd "lua MiniBracketed.buffer('backward')") "Prev buffer")
  (map :n    :L           (cmd "lua MiniBracketed.buffer('forward')")  "Next buffer")
  (map :n    :z=          (cmd "Pick spellsuggest")                    "Spelling suggestions")
  (map :n    "[p"         (cmd "exe 'iput! ' . v:register")            "Paste above")
  (map :n    "]p"         (cmd "exe 'iput ' . v:register")             "Paste below")
  (map :n    "\\f"        (ext "plugins.conform" "toggle()")           "Toggle auto-format")
  (map :n    "\\H"        (ext "plugins.lsp" "toggle_hints()")         "Toggle inlay hints")
  (map :n    "\\W"        (ext "plugins.mini-cursorword" "toggle()")   "Toggle cursor word")
  (map :nxo  :sj          "<Plug>(leap)"                               "Leap anywhere")
  (map :nxo  :S           (ext "leap.treesitter" "select()")           "Treesitter select"))

;; ---------------------------------------------------------------------------
;; Frequently Used Pickers
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr " ")  (cmd "Pick files")                                         "Find files")
  (map :n  (ldr ",")  (cmd "Pick buffers")                                       "Switch buffer")
  (map :n  (ldr "/")  (cmd "Pick buf_lines scope='current' preserve_order=true") "Lines (current)"))

;; ---------------------------------------------------------------------------
;; Buffer
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :ba)  (cmd "b#")                                             "Alternate buffer")
  (map :n  (ldr :bd)  (cmd "lua MiniBufremove.delete()")                     "Delete buffer")
  (map :n  (ldr :bD)  (cmd "%bd|e#|bd#")                                     "Delete other buffers")
  (map :n  (ldr :bp)  (ext "plugins.mini-tabline" "toggle_pinned()")         "Pin buffer")
  (map :n  (ldr :bP)  (ext "plugins.mini-tabline" "remove_pinned('delete')") "Delete non-pinned")
  (map :n  (ldr :bs)  (ext "config.functions" "new_scratch_buffer()")        "New scratch buffer")
  (map :n  (ldr :bt)  (cmd "lua MiniTrailspace.trim()")                      "Trim trailspace")
  (map :n  (ldr :bu)  (cmd "lua MiniBufremove.unshow()")                     "Unshow buffer")
  (map :n  (ldr :bw)  (cmd "lua MiniBufremove.wipeout()")                    "Wipeout buffer"))

;; ---------------------------------------------------------------------------
;; Copilot
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :nx  (ldr :cc)  (cmd "CodeCompanionChat Toggle") "Code Companion chat")
  (map :nx  (ldr :cC)  (cmd :CodeCompanionActions)      "Code Companion actions"))

;; ---------------------------------------------------------------------------
;; Explore
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :ec)  (cmd "Pick config")                           "Pick config file")
  (map :n  (ldr :ed)  (cmd "lua MiniFiles.open()")                  "Directory (cwd)")
  (map :n  (ldr :ef)  (ext "plugins.mini-files" "open_bufdir()")    "Directory (file)")
  (map :n  (ldr :el)  (ext "quicker" "toggle({ loclist = true })")  "Location list")
  (map :n  (ldr :en)  (cmd "lua MiniNotify.show_history()")         "Notification history")
  (map :n  (ldr :ep)  (cmd "Pick plugins")                          "Pick plugin")
  (map :n  (ldr :eq)  (ext "quicker" "toggle()")                    "Quickfix toggle")
  (map :n  (ldr :er)  (cmd "Pick projects")                         "Pick projects")
  (map :n  (ldr :eu)  (cmd :Undotree)                               "Open undotree"))

;; ---------------------------------------------------------------------------
;; Find
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :f/)  (cmd "Pick history scope='/'")                             "'/' history")
  (map :n  (ldr "f:") (cmd "Pick history scope=':'")                             "':' history")
  (map :n  (ldr :fa)  (cmd "Pick git_hunks scope='staged'")                      "Added hunks (all)")
  (map :n  (ldr :fA)  (cmd "Pick git_hunks path='%' scope='staged'")             "Added hunks (buf)")
  (map :n  (ldr :fb)  (cmd "Pick buffers")                                       "Pick buffer")
  (map :n  (ldr :fc)  (cmd "Pick git_commits")                                   "Commits (all)")
  (map :n  (ldr :fC)  (cmd "Pick git_commits path='%'")                          "Commits (buf)")
  (map :n  (ldr :fd)  (cmd "Pick diagnostic scope='all'")                        "Diagnostic (workspace)")
  (map :n  (ldr :fD)  (cmd "Pick diagnostic scope='current'")                    "Diagnostic (buf)")
  (map :n  (ldr :ff)  (cmd "Pick files")                                         "Pick file")
  (map :n  (ldr :fg)  (cmd "Pick grep_live_align")                               "Grep live")
  (map :n  (ldr :fG)  (cmd "Pick grep_align pattern='<cword>'")                  "Grep current word")
  (map :n  (ldr :fh)  (cmd "Pick help")                                          "Help tags")
  (map :n  (ldr :fH)  (cmd "Pick hl_groups")                                     "Highlight groups")
  (map :n  (ldr :fl)  (cmd "Pick buf_lines scope='all' preserve_order=true")     "Lines (all)")
  (map :n  (ldr :fL)  (cmd "Pick buf_lines scope='current' preserve_order=true") "Lines (buf)")
  (map :n  (ldr :fm)  (cmd "Pick git_hunks")                                     "Modified hunks (all)")
  (map :n  (ldr :fM)  (cmd "Pick git_hunks path='%'")                            "Modified hunks (buf)")
  (map :n  (ldr :fr)  (cmd "Pick resume")                                        "Resume picker")
  (map :n  (ldr :fR)  (cmd "Pick lsp_align scope='references'")                  "References (LSP)")
  (map :n  (ldr :fs)  (cmd "Pick lsp_align scope='workspace_symbol'")            "Symbols workspace")
  (map :n  (ldr :fS)  (cmd "Pick lsp_align scope='document_symbol'")             "Symbols document")
  (map :n  (ldr :ft)  (cmd "Pick grep_todo_keywords")                            "Search todo/fixme/hack")
  (map :n  (ldr :fT)  (cmd "Pick colorschemes")                                  "Choose colorscheme")
  (map :n  (ldr :fv)  (cmd "Pick visit_paths cwd=''")                            "Visit paths (all)")
  (map :n  (ldr :fV)  (cmd "Pick visit_paths")                                   "Visit paths (cwd)"))

;; ---------------------------------------------------------------------------
;; Git
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :ga)  (cmd "Git diff --cached")                "Added diff")
  (map :n  (ldr :gA)  (cmd "Git diff --cached -- %")           "Added diff (buf)")
  (map :nx (ldr :gb)  (cmd "lua MiniGit.show_range_history()") "Range history")
  (map :n  (ldr :gc)  (cmd "Git commit")                       "Commit ")
  (map :n  (ldr :gC)  (cmd "Git commit --amend")               "Commit amend")
  (map :n  (ldr :gd)  (cmd "Git diff")                         "Git diff")
  (map :n  (ldr :gD)  (cmd "Git diff -- %")                    "Git diff (buf)")
  (map :n  (ldr :gg)  (ext "plugins.toggleterm" "lazygit()")   "Toggle Lazygit")
  (map :n  (ldr :gl)  (ext "plugins.mini-git" "log()")         "Git log")
  (map :n  (ldr :gL)  (ext "plugins.mini-git" "log_buf()")     "Git log (buf)")
  (map :n  (ldr :go)  (cmd "lua MiniDiff.toggle_overlay()")    "Toggle overlay")
  (map :n  (ldr :gq)  (ext "plugins.mini-diff" "to_qf()")      "Quickfix diffs")
  (map :nx (ldr :gs)  (cmd "lua MiniGit.show_at_cursor()")     "Show at cursor"))

;; ---------------------------------------------------------------------------
;; Language
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :nx (ldr :la)  (cmd "lua vim.lsp.buf.code_action()")     "Code actions")
  (map :n  (ldr :ld)  (cmd "lua vim.diagnostic.open_float()")   "Diagnostic popup")
  (map :nx (ldr :lf)  (ext "conform" "format()")                "Format buffer")
  (map :n  (ldr :li)  (cmd "lua vim.lsp.buf.implementation()")  "LSP Implementation")
  (map :n  (ldr :lI)  (cmd :LspInfo)                            "LSP info")
  (map :n  (ldr :lh)  (cmd "lua vim.lsp.buf.hover()")           "LSP Hover")
  (map :n  (ldr :ll)  (cmd "lua vim.lsp.codelens.run()")        "Run codelens")
  (map :n  (ldr :lL)  (cmd "lua vim.lsp.codelens.refresh()")    "Refresh & display codelens")
  (map :n  (ldr :lr)  (cmd "lua vim.lsp.buf.rename()")          "LSP Rename")
  (map :n  (ldr :lR)  (cmd "lua vim.lsp.buf.references()")      "LSP References")
  (map :n  (ldr :ls)  (cmd "lua vim.lsp.buf.definition()")      "Source definition")
  (map :n  (ldr :lt)  (cmd "lua vim.lsp.buf.type_definition()") "Type definition"))

;; ---------------------------------------------------------------------------
;; Map
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :mf)  (cmd "lua MiniMap.toggle_focus()")      "Focus map")
  (map :n  (ldr :mr)  (cmd "lua MiniMap.refresh()")           "Refresh map")
  (map :n  (ldr :ms)  (cmd "lua MiniMap.toggle_side()")       "Switch sides")
  (map :n  (ldr :mt)  (ext "plugins.mini-map" "toggle()")     "Toggle map")
  (map :n  (ldr :mT)  (ext "plugins.mini-map" "buf_toggle()") "Toggle map (buf)"))

;; ---------------------------------------------------------------------------
;; Org
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :of)  (ext "plugins.orgmode" "files()")             "Open org file")
  (map :n  (ldr :oh)  (ext "plugins.orgmode" "headlines()")         "Search headlines")
  (map :n  (ldr :om)  (ext "plugins.orgmode" "new_meeting_entry()") "New meeting entry")
  (map :n  (ldr :o/)  (ext "plugins.orgmode" "grep()")              "Grep all lines"))

;; ---------------------------------------------------------------------------
;; Other
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :Oa)  (cmd :Mason)                               "Open Mason")
  (map :n  (ldr :Os)  (cmd "lua MiniStarter.open()")             "Open MiniStarter")
  (map :n  (ldr :Ou)  (cmd "lua vim.pack.update()")              "Update plugins"))

;; ---------------------------------------------------------------------------
;; Session
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :sd)  (cmd "lua MiniSessions.select('delete')")              "Delete session")
  (map :n  (ldr :sl)  (cmd "lua MiniSessions.select('read')")                "Load session")
  (map :n  (ldr :sn)  (cmd "lua MiniSessions.write(vim.fn.input('Name: '))") "New session")
  (map :n  (ldr :sr)  (cmd "lua MiniSessions.restart()")                     "Restart session")
  (map :n  (ldr :ss)  (cmd "lua MiniSessions.write()")                       "Save session"))

;; ---------------------------------------------------------------------------
;; Visits
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :va)  (cmd "Pick visit_labels cwd=''")               "All labels")
  (map :n  (ldr :vc)  (ext "plugins.mini-visits" "pick('','core')")  "Core visits (all)")
  (map :n  (ldr :vC)  (ext "plugins.mini-visits" "pick(nil,'core')") "Core visits (cwd)")
  (map :n  (ldr :vl)  (cmd "lua MiniVisits.add_label()")             "Add label")
  (map :n  (ldr :vL)  (cmd "lua MiniVisits.remove_label()")          "Remove label")
  (map :n  (ldr :vv)  (cmd "lua MiniVisits.add_label('core')")       "Add core label")
  (map :n  (ldr :vV)  (cmd "lua MiniVisits.remove_label('core')")    "Remove core label"))

;; ---------------------------------------------------------------------------
;; Window
;; ---------------------------------------------------------------------------

;; fnlfmt: skip
(do
  (map :n  (ldr :wr)  (cmd "lua MiniMisc.resize_window()") "Resize to default width")
  (map :n  (ldr :wz)  (cmd "lua MiniMisc.zoom()")          "Zoom window"))

{:leader_group_clues leader-group-clues}
