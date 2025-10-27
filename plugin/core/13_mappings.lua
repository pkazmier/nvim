-- stylua: ignore start

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Mapping helpers to make clean and easy to align with mini.align
local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(vim.split(mode, ""), lhs, rhs, opts)
end

local L = function(key) return "<leader>" .. key end
local C = function(cmd) return "<Cmd>" .. cmd .. "<CR>" end

-- ---------------------------------------------------------------------------
-- Leader Groups
-- ---------------------------------------------------------------------------

-- Leader mappings and descriptions used later when mini.clue is setup
Config.leader_group_clues = {
  { mode = "n", keys = L"b",  desc = "+Buffer" },
  { mode = "n", keys = L"c",  desc = "+Copilot" },
  { mode = "n", keys = L"e",  desc = "+Explore" },
  { mode = "n", keys = L"f",  desc = "+Find" },
  { mode = "n", keys = L"g",  desc = "+Git" },
  { mode = "n", keys = L"l",  desc = "+Language" },
  { mode = "n", keys = L"m",  desc = "+Map" },
  { mode = "n", keys = L"n",  desc = "+Notes" },
  { mode = "n", keys = L"o",  desc = "+Other" },
  { mode = "n", keys = L"s",  desc = "+Session" },
  { mode = "n", keys = L"v",  desc = "+Visits" },
  { mode = "n", keys = L"w",  desc = "+Window" },
}

-- ---------------------------------------------------------------------------
-- Basic Mappings
-- ---------------------------------------------------------------------------

map("i",   "<A-Space>", C"normal ciw ",                                        "Just one space")
map("n",   "z=",        C"Pick spellsuggest",                                  "Spelling suggestions")
map("n",   "[p",        C'exe "put! " . v:register',                           "Paste Above")
map("n",   "]p",        C'exe "put "  . v:register',                           "Paste Below")
map("n",   [[\f]],      C"FormatToggle",                                       "Toggle auto-format")
map("n",   [[\H]],      C"lua Config.toggle_hints()",                          "Toggle inlay hints")
map("n",   [[\W]],      C"lua Config.minicursorword_toggle()",                 "Toggle cursor word")
map("nxo", "sj",        "<Plug>(leap)",                                        "Leap anywhere")
map("nxo", "S",         C"lua require('leap.treesitter').select()",            "Treesitter select")

-- ---------------------------------------------------------------------------
-- Frequently Used Pickers
-- ---------------------------------------------------------------------------

map("n",   L" ",        C"Pick files",                                         "Find files")
map("n",   L",",        C"Pick buffers",                                       "Switch buffer")
map("n",   L"/",        C"Pick buf_lines scope='current' preserve_order=true", "Lines (current)")

-- ---------------------------------------------------------------------------
-- Buffer
-- ---------------------------------------------------------------------------

map("n",   L"ba",       C"b#",                                                 "Alternate buffer")
map("n",   L"bd",       C"lua MiniBufremove.delete()",                         "Delete buffer")
map("n",   L"bD",       C"%bd|e#|bd#",                                         "Delete other buffers")
map("n",   L"bs",       C"lua Config.new_scratch_buffer()",                    "New scratch buffer")
map("n",   L"bt",       C"lua MiniTrailspace.trim()",                          "Trim trailspace")
map("n",   L"bu",       C"lua MiniBufremove.unshow()",                         "Unshow buffer")
map("n",   L"bw",       C"lua MiniBufremove.wipeout()",                        "Wipeout buffer")

-- ---------------------------------------------------------------------------
-- Copilot
-- ---------------------------------------------------------------------------

map("nx",  L"cc",       C"CodeCompanionChat Toggle",                           "Code Companion chat")
map("nx",  L"cC",       C"CodeCompanionActions",                               "Code Companion actions")

-- ---------------------------------------------------------------------------
-- Explore
-- ---------------------------------------------------------------------------

map("n",   L"ec",       C"Pick config",                                        "Config")
map("n",   L"ed",       C"lua MiniFiles.open()",                               "Directory (cwd)")
map("n",   L"ef",       C"lua Config.minifiles_open_bufdir()",                 "Directory (file)")
map("n",   L"el",       C"lua require('quicker').toggle({ loclist = true })",  "Location list")
map("n",   L"en",       C"lua MiniNotify.show_history()",                      "Notifications")
map("n",   L"ep",       C"Pick plugins",                                       "Plugins")
map("n",   L"eq",       C"lua require('quicker').toggle()",                    "Quickfix")
map("n",   L"er",       C"Pick projects",                                      "Projects")
map("n",   L"eu",       C"Undotree",                                           "Undotree")

-- ---------------------------------------------------------------------------
-- Find
-- ---------------------------------------------------------------------------

map("n",   L"f/",       C"Pick history scope='/'",                             '"/" history')
map("n",   L"f:",       C"Pick history scope=':'",                             '":" history')
map("n",   L"fa",       C"Pick git_hunks scope='staged'",                      "Added hunks (all)")
map("n",   L"fA",       C"Pick git_hunks path='%' scope='staged'",             "Added hunks (buf)")
map("n",   L"fb",       C"Pick buffers",                                       "Buffers")
map("n",   L"fc",       C"Pick git_commits",                                   "Commits (all)")
map("n",   L"fC",       C"Pick git_commits path='%'",                          "Commits (buf)")
map("n",   L"fd",       C"Pick diagnostic scope='all'",                        "Diagnostic (workspace)")
map("n",   L"fD",       C"Pick diagnostic scope='current'",                    "Diagnostic (buf)")
map("n",   L"ff",       C"Pick files",                                         "Files")
map("n",   L"fg",       C"Pick grep_live_align",                               "Grep live")
map("n",   L"fG",       C"Pick grep_align pattern='<cword>'",                  "Grep current word")
map("n",   L"fh",       C"Pick help",                                          "Help tags")
map("n",   L"fH",       C"Pick hl_groups",                                     "Highlight groups")
map("n",   L"fl",       C"Pick buf_lines scope='all' preserver_order=true",    "Lines (all)")
map("n",   L"fL",       C"Pick buf_lines scope='current' preserve_order=true", "Lines (buf)")
map("n",   L"fm",       C"Pick git_hunks",                                     "Modified hunks (all)")
map("n",   L"fM",       C"Pick git_hunks path='%'",                            "Modified hunks (buf)")
map("n",   L"fr",       C"Pick resume",                                        "Resume")
map("n",   L"fR",       C"Pick lsp scope='references'",                        "References (LSP)")
map("n",   L"fs",       C"Pick lsp scope='workspace_symbol'",                  "Symbols workspace")
map("n",   L"fS",       C"Pick lsp scope='document_symbol'",                   "Symbols document")
map("n",   L"ft",       C"Pick grep_todo_keywords",                            "Search todo/fixme/hack/note")
map("n",   L"fT",       C"Pick colorschemes",                                  "Search colorschemes")
map("n",   L"fv",       C"Pick visit_paths cwd=''",                            "Visit paths (all)")
map("n",   L"fV",       C"Pick visit_paths",                                   "Visit paths (cwd)")

-- ---------------------------------------------------------------------------
-- Git
-- ---------------------------------------------------------------------------

map("n",   L"ga",       C"Git diff --cached",                                  "Added diff")
map("n",   L"gA",       C"Git diff --cached -- %",                             "Added diff (buf)")
map("nx",  L"gb",       C"lua MiniGit.show_range_history()",                   "Range history")
map("n",   L"gc",       C"Git commit",                                         "Commit")
map("n",   L"gC",       C"Git commit --amend",                                 "Commit amend")
map("n",   L"gd",       C"Git diff",                                           "Diff")
map("n",   L"gD",       C"Git diff -- %",                                      "Diff (buf)")
map("n",   L"gg",       C"lua Config.toggleterm_lazygit()",                    "Toggle Lazygit")
map("n",   L"gl",       C"lua Config.minigit_log()",                           "Log")
map("n",   L"gL",       C"lua Config.minigit_log_buf()",                       "Log (buf)")
map("n",   L"go",       C"lua MiniDiff.toggle_overlay()",                      "Toggle overlay")
map("n",   L"gq",       C"lua Config.minidiff_to_qf()",                        "Quickfix diffs")
map("nx",  L"gs",       C"lua MiniGit.show_at_cursor()",                       "Show at cursor")

-- ---------------------------------------------------------------------------
-- Language
-- ---------------------------------------------------------------------------

map("nx",  L"la",       C"lua vim.lsp.buf.code_action()",                      "Actions")
map("n",   L"ld",       C"lua vim.diagnostic.open_float()",                    "Diagnostic popup")
map("nx",  L"lf",       C"lua require('conform').format({lsp_fallback=true})", "Format")
map("n",   L"li",       C"lua vim.lsp.buf.implementation()",                   "Implementation")
map("n",   L"lI",       C"LspInfo",                                            "LSP info")
map("n",   L"lh",       C"lua vim.lsp.buf.hover()",                            "Hover")
map("n",   L"ll",       C"lua vim.lsp.codelens.run()",                         "Run codelens")
map("n",   L"lL",       C"lua vim.lsp.codelens.refresh()",                     "Refresh & display codelens")
map("n",   L"lr",       C"lua vim.lsp.buf.rename()",                           "Rename")
map("n",   L"lR",       C"lua vim.lsp.buf.references()",                       "References")
map("n",   L"ls",       C"lua vim.lsp.buf.definition()",                       "Source definition")
map("n",   L"lt",       C"lua vim.lsp.buf.type_definition()",                  "Type definition")

-- ---------------------------------------------------------------------------
-- Map
-- ---------------------------------------------------------------------------

map("n",   L"mf",       C"lua MiniMap.toggle_focus()",                         "Focus")
map("n",   L"mr",       C"lua MiniMap.refresh()",                              "Refresh")
map("n",   L"ms",       C"lua MiniMap.toggle_side()",                          "Switch sides")
map("n",   L"mt",       C"lua Config.minimap_toggle()",                        "Toggle map")
map("n",   L"mT",       C"lua Config.minimap_buf_toggle()",                    "Toggle map (buf)")

-- ---------------------------------------------------------------------------
-- Notes
-- ---------------------------------------------------------------------------

map("n",   L"nb",       C"ZkBacklinks",                                        "Backlink picker")
map("n",   L"nd",       C"ZkCd",                                               "Change directory")
map("n",   L"nl",       C"ZkLinks",                                            "Link picker")
map("n",   L"nm",       C"ZkFullTextSearch",                                   "Search (FTS)")
map("n",   L"nn",       C"ZkNew { title = vim.fn.input('Title: ')}",           "New note")
map("n",   L"nN",       C"ZkNewMeeting",                                       "New meeting note")
map("n",   L"np",       C"ZkPriorMeetings",                                    "Prior meetings")
map("n",   L"nr",       C"ZkIndex",                                            "Refresh index")
map("n",   L"ns",       C"ZkNotes { sort = { 'created' } }",                   "Search")
map("n",   L"nt",       C"ZkTags",                                             "Tags")

-- ---------------------------------------------------------------------------
-- Other
-- ---------------------------------------------------------------------------

map("n",   L"oa",       C"Mason",                                              "Mason")
map("n",   L"os",       C"lua MiniStarter.open()",                             "Open MiniStarter")
map("n",   L"ou",       C"lua vim.pack.update()",                              "Update deps")
map("n",   L"ox",       C"lua Config.export_minihues_theme()",                 "Export mini.hues theme")

-- ---------------------------------------------------------------------------
-- Session
-- ---------------------------------------------------------------------------

map("n",   L"sd",       C"lua MiniSessions.select('delete')",                  'Delete session')
map("n",   L"sl",       C"lua MiniSessions.select('read')",                    'Load session')
map("n",   L"sn",       C"lua MiniSessions.write(vim.fn.input('Name: '))",     'New session')
map("n",   L"ss",       C"lua MiniSessions.write()",                           'Save session')

-- ---------------------------------------------------------------------------
-- Visits
-- ---------------------------------------------------------------------------

map("n",   L"va",       C"Pick visit_labels cwd=''",                           "All labels")
map("n",   L"vc",       C"lua Config.minivisits_pick('', 'core')",             'Core visits (all)')
map("n",   L"vC",       C"lua Config.minivisits_pick(nil, 'core')",            'Core visits (cwd)')
map("n",   L"vl",       C"lua MiniVisits.add_label()",                         "Add label")
map("n",   L"vL",       C"lua MiniVisits.remove_label()",                      "Remove label")
map("n",   L"vv",       C"lua MiniVisits.add_label('core')",                   "Add core label")
map("n",   L"vV",       C"lua MiniVisits.remove_label('core')",                "Remove core label")

-- ---------------------------------------------------------------------------
-- Window
-- ---------------------------------------------------------------------------

map("n",   L"wr",       C"lua MiniMisc.resize_window()",                       "Resize to default width")
map("n",   L"wz",       C"lua MiniMisc.zoom()",                                "Zoom window")

-- stylua: ignore end
