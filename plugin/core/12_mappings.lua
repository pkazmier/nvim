--stylua: ignore start
-- Mapping helpers
local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local L = function(key) return "<leader>" .. key end
local C = function(cmd) return "<Cmd>" .. cmd .. "<CR>" end

-- Leader mappings
Config.leader_group_clues = {
  { mode = "n", keys = L"b",  desc = "+Buffers" },
  { mode = "n", keys = L"c",  desc = "+Code" },
  { mode = "n", keys = L"f",  desc = "+Files" },
  { mode = "n", keys = L"fg", desc = "+Git Files" },
  { mode = "n", keys = L"g",  desc = "+Git/Diff" },
  { mode = "n", keys = L"m",  desc = "+Mini" },
  { mode = "n", keys = L"md", desc = "+Deps" },
  { mode = "n", keys = L"mm", desc = "+Map" },
  { mode = "n", keys = L"n",  desc = "+Zk Notes" },
  { mode = "n", keys = L"s",  desc = "+Search" },
  { mode = "n", keys = L"q",  desc = "+Quit/Session" },
  { mode = "n", keys = L"v",  desc = "+Visits" },
  { mode = "n", keys = L"w",  desc = "+Window" },
}

-- Basic mappings
map("i",             "<A-Space>", C"normal ciw ",                             "Just one space")
map("n",             "-",         C"lua Config.minifiles_open_bufdir()",      "Open mini.files")
map("n",             "H",         C"lua MiniBracketed.buffer('backward')",    "Prev buffer")
map("n",             "L",         C"lua MiniBracketed.buffer('forward')",     "Next buffer")
map("n",             "z=",        C"Pick spellsuggest",                       "Spelling suggestions")
map("n",             [[\f]],      C"FormatToggle",                            "Toggle auto-format")
map("n",             [[\H]],      C"lua Config.toggle_hints()",               "Toggle inlay hints")
map("n",             "M",         "m",                                        "Mark", { noremap = true, silent = true })
map({ "n","x","o" }, "m",         "<Plug>(leap-anywhere)",                    "Leap anywhere")
map({ "n","x","o" }, "S",         C"lua require('leap.treesitter').select()", "Treesitter select")

-- Frequently used
map("n",       L" ",   C"Pick files",                                         "Find files")
map("n",       L",",   C"Pick buffers",                                       "Switch buffer")
map("n",       L"/",   C"Pick buf_lines scope='current' preserve_order=true", "Lines (current)")

-- Code
map({"n","x"}, L"ca",  C"lua vim.lsp.buf.code_action()",                      "Code action")
map({"n","x"}, L"cc",  C"CodeCompanionChat Toggle",                           "Code Companion chat")
map({"n","x"}, L"cC",  C"CodeCompanionActions",                               "Code Companion actions")
map("n",       L"cd",  C"lua vim.lsp.bup.definition()",                       "Goto definition")
map("n",       L"cD",  C"Pick lsp scope='declaration'",                       "Goto declaration")
map("n",       L"ci",  C"LspInfo",                                            "LSP info")
map("n",       L"cI",  C"Pick lsp scope='implementation'",                    "Goto implementation")
map("n",       L"cj",  C"lua vim.diagnostic.jump({count=1, float=true})",     "Next diagnostic")
map("n",       L"ck",  C"lua vim.diagnostic.jump({count=-1, float=true})",    "Prev diagnostic")
map("n",       L"cl",  C"lua vim.lsp.codelens.run()",                         "Run codelens")
map("n",       L"cL",  C"lua vim.lsp.codelens.refresh()",                     "Refresh & display codelens")
map("n",       L"cr",  C"lua vim.lsp.buf.rename()",                           "Rename")
map("n",       L"cR",  C"Pick lsp scope='references'",                        "References (LSP)")
map("n",       L"cs",  C"Pick lsp scope='document_symbol'",                   "Symbols (current)")
map("n",       L"cS",  C"Pick lsp scope='workspace_symbol'",                  "Symbols (all)")
map("n",       L"cy",  C"Pick lsp scope='type_definition'",                   "Goto t[y]pe definition")

-- Buffer
map("n",       L"ba",  C"b#",                                                 "Alternate buffer")
map("n",       L"bd",  C"lua MiniBufremove.delete()",                         "Delete buffer")
map("n",       L"bD",  C"%bd|e#|bd#",                                         "Delete other buffers")
map("n",       L"bu",  C"lua MiniBufremove.unshow()",                         "Unshow buffer")
map("n",       L"bw",  C"lua MiniBufremove.wipeout()",                        "Wipeout buffer")

-- File
map("n",       L"ff",  C"lua Config.minifiles_open_bufdir()",                 "File directory")
map("n",       L"fF",  C"lua MiniFiles.open()",                               "directory")
map("n",       L"fb",  C"Pick buffers",                                       "Find buffers")
map("n",       L"fc",  C"Pick config",                                        "Find config file")
map("n",       L"fgd", C"Pick git_files scope='deleted'",                     "Find deleted files")
map("n",       L"fgg", C"Pick git_files",                                     "Find git files")
map("n",       L"fgi", C"Pick git_files scope='ignored'",                     "Find ignored files")
map("n",       L"fgm", C"Pick git_files scope='modified'",                    "Find modified files")
map("n",       L"fgu", C"Pick git_files scope='untracked'",                   "Find untracked files")
map("n",       L"fr",  C"Pick oldfiles",                                      "Find recent files")

-- Git
map("n",       L"ga",  C'Pick git_hunks scope="staged"',                      "Added hunks (all)")
map("n",       L"gA",  C'Pick git_hunks path="%" scope="staged"',             "Added hunks (current)")
map("n",       L"gb",  C"vertical Git blame -- %",                            "Git blame")
map("n",       L"gc",  C"Pick git_commits",                                   "Commits (all)")
map("n",       L"gC",  C'Pick git_commits path="%"',                          "Commits (current)")
map("n",       L"gg",  C"lua Config.lazygit_toggle()",                        "Toggle Lazygit")
map("n",       L"gl",  C"Git hist",                                           "Git history")
map("n",       L"gL",  C"Git hist --all",                                     "Git history (all)")
map("n",       L"gm",  C"Pick git_hunks",                                     "Modified hunks (all)")
map("n",       L"gM",  C'Pick git_hunks path="%"',                            "Modified hunks (current)")
map("n",       L"go",  C"lua MiniDiff.toggle_overlay()",                      "Toggle diff")
map("n",       L"gq",  C"lua Config.minidiff_to_qf()",                        "Quickfix diffs")
map("n",       L"gs",  C"lua MiniGit.show_at_cursor()",                       "MiniGit show at cursor")

-- Mini / System
map("n",       L"ma",  C"Mason",                                              "Mason")
map("n",       L"mh",  C"lua MiniNotify.show_history()",                      "Show notifications")
map("n",       L"mdc", C"DepsClean",                                          "Clean deps")
map("n",       L"mdh", C"DepsShowLog",                                        "Show log")
map("n",       L"mdl", C"DepsSnapLoad",                                       "Load snapshot")
map("n",       L"mds", C"DepsSnapSave",                                       "Save snapshot")
map("n",       L"mdu", C"lua vim.pack.update()",                              "Update deps")
map("n",       L"mmf", C"lua MiniMap.toggle_focus()",                         "Focus")
map("n",       L"mmr", C"lua MiniMap.refresh()",                              "Refresh")
map("n",       L"mms", C"lua MiniMap.toggle_side()",                          "Switch sides")
map("n",       L"mmt", C"lua Config.minimap_toggle()",                        "Toggle map")
map("n",       L"mmT", C"lua Config.minimap_buf_toggle()",                    "Toggle map (buf)")
map("n",       L"ms",  C"lua MiniStarter.open()",                             "Open MiniStarter")
map("n",       L"mx",  C"lua Config.export_minihues_theme()",                 "Export mini.hues theme")

-- Zk Notes
map("n",       L"nN",  C"ZkNewMeeting",                                       "New meeting note")
map("n",       L"nb",  C"ZkBacklinks",                                        "Backlink picker")
map("n",       L"nd",  C"ZkCd",                                               "Change directory")
map("n",       L"nl",  C"ZkLinks",                                            "Link picker")
map("n",       L"nm",  C"ZkFullTextSearch",                                   "Search (FTS)")
map("n",       L"nn",  C"ZkNew { title = vim.fn.input('Title: ')}",           "New note")
map("n",       L"np",  C"ZkPriorMeetings",                                    "Prior meetings")
map("n",       L"nr",  C"ZkIndex",                                            "Refresh index")
map("n",       L"ns",  C"ZkNotes { sort = { 'created' } }",                   "Search")
map("n",       L"nt",  C"ZkTags",                                             "Tags")

-- Search
map("n",       L's"',  C"Pick registers",                                     "Search registers")
map("n",       L"sb",  C"Pick buf_lines scope='all' preserve_order=true",     "Lines (all)")
map("n",       L"sB",  C"Pick buf_lines scope='current' preserve_order=true", "Lines (current)")
map("n",       L"sc",  C"Pick history",                                       "Search history")
map("n",       L"sC",  C"Pick commands",                                      "Search commands")
map("n",       L"sd",  C'Pick diagnostic scope="all"',                        "Diagnostic workspace")
map("n",       L"sD",  C'Pick diagnostic scope="current"',                    "Diagnostic buffer")
map("n",       L"sg",  C"Pick grep_live_align",                               "Search files (align)")
map("n",       L"sh",  C"Pick help",                                          "Search help")
map("n",       L"sH",  C"Pick hl_groups",                                     "Search highlight groups")
map("n",       L"sk",  C"Pick keymaps",                                       "Search keymaps")
map("n",       L"so",  C"Pick options",                                       "Search options")
map("n",       L"sr",  C"Pick resume",                                        "Resume picker")
map("n",       L"ss",  C"Pick colorschemes",                                  "Search colorschemes")
map("n",       L"st",  C"Pick grep_todo_keywords",                            "Search todo/fixme/hack/note")
map("n",       L"sT",  C"Pick treesitter",                                    "Treesitter objects")

-- Quit / Session
map("n",       L"qd",  C"lua Config.session_delete()",                        "Delete session")
map("n",       L"ql",  C"lua MiniSessions.select()",                          "Load session")
map("n",       L"qq",  C"qa",                                                 "Quit all")
map("n",       L"qs",  C"lua Config.session_save()",                          "Save session")

-- Visits
map("n",       L"va",  C"lua MiniVisits.add_label()",                         "Add label")
map("n",       L"vl",  C"Pick visit_labels cwd=''",                           "Find visited labels")
map("n",       L"vr",  C"lua MiniVisits.remove_label()",                      "Remove label")
map("n",       L"vv",  C"Pick visit_paths cwd=''",                            "Visit paths (all)")
map("n",       L"vV",  C"Pick visit_paths",                                   "Visit paths (cwd)")

-- Window
map("n",       L"wz",  C"lua MiniMisc.zoom()",                                "Zoom window")
map("n",       L"wl",  C"lua require('quicker').toggle({ loclist = true })",  "Open location list")
map("n",       L"wq",  C"lua require('quicker').toggle()",                    "Open quickfix")

--stylua: ignore end
