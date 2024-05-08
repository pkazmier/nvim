--stylua: ignore start

-- Mapping helpers ==========================================================
local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local imap = function (...) map("i", ...) end
local nmap = function (...) map("n", ...) end
local tmap = function (...) map("t", ...) end
local xmap = function (...) map("x", ...) end

local L = function (key) return "<leader>" .. key end
local C = function (cmd) return "<Cmd>" .. cmd .. "<CR>" end

-- Basic mappings ===========================================================
imap("jk",         "<esc>",                                         "Exit insert mode", { silent = true })
imap("<C-k>",      C"lua vim.lsp.buf.signature_help()",             "Signature help")
tmap("<Esc><Esc>", "<C-\\><C-n>",                                   "Exit terminal mode")
nmap("-",          C"lua require('plugins.mini.files').bufdir()",   "File explorer (buf)")
nmap("H",          C"lua MiniBracketed.buffer('backward')",         "Prev buffer")
nmap("K",          C"lua vim.lsp.buf.hover()",                      "Hover documentation")
nmap("L",          C"lua MiniBracketed.buffer('forward')",          "Next buffer")
nmap("gD",         C"Pick lsp scope='declaration'",                 "Goto declaration")
nmap("gd",         C"Pick lsp scope='definition'",                  "Goto definition")
nmap("gi",         C"Pick lsp scope='implementation'",              "Goto implementation")
-- "gr" used by mini.operators
nmap("gR",         C"Pick lsp scope='references'",                  "Goto references")
nmap("gy",         C"Pick lsp scope='type_definition'",             "Goto t[y]pe definition")
nmap("z=",         C"Pick spellsuggest",                            "Spelling suggestions")
nmap([[\c]],       C"lua require('reticle').toggle_cursorline()",   "Toggle 'cursorline'")
nmap([[\C]],       C"lua require('reticle').toggle_cursorcolumn()", "Toggle 'cursorcolumn'")
nmap([[\f]],       C"FormatToggle",                                 "Toggle auto-format")
-- Cannot use <Cmd> or mini.map will not refresh.
nmap([[\h]],       ":let v:hlsearch = 1 - v:hlsearch<CR>",          "Toggle hlsearch")

-- Leader mappings ==========================================================
nmap(L" ",   C"Pick files",                                       "Find files")
nmap(L",",   C"Pick buffers",                                     "Switch buffer")
nmap(L"/",   C"Pick buf_lines scope='current'",                   "Search buffer")
nmap(L"bd",  C"lua require('mini.bufremove').delete()",           "Delete buffer")
nmap(L"bu",  C"lua require('mini.bufremove').unshow()",           "Unshow buffer")
nmap(L"bw",  C"lua require('mini.bufremove').wipeout()",          "Wipeout buffer")
nmap(L"cd",  C"lua vim.diagnostic.open_float()",                  "Show diagnostic messages")
nmap(L"cr",  C"lua vim.lsp.buf.rename()",                         "Rename symbol")
nmap(L"ca",  C"lua vim.lsp.buf.code_action()",                    "Code Action")
nmap(L"fE",  C"lua require('plugins.mini.files').cwd()",          "File explorer (cwd)")
nmap(L"fL",  C"lua MiniVisits.remove_label()",                    "Remove label")
nmap(L"fV",  C"Pick visit_labels",                                "Find visited labels")
nmap(L"fb",  C"Pick buffers",                                     "Find buffers")
nmap(L"fc",  C"Pick config",                                      "Find config file")
nmap(L"fe",  C"lua require('plugins.mini.files').bufdir()",       "File explorer (buf)")
nmap(L"ff",  C"Pick files",                                       "Find files")
nmap(L"fl",  C"lua MiniVisits.add_label()",                       "Add label")
nmap(L"fr",  C"Pick oldfiles",                                    "Find recent files")
nmap(L"fv",  C"Pick visit_paths",                                 "Find visited files")
nmap(L"gfd", C"Pick git_files scope='deleted'",                   "Find deleted files")
nmap(L"gfg", C"Pick git_files",                                   "Find git files")
nmap(L"gfi", C"Pick git_files scope='ignored'",                   "Find ignored files")
nmap(L"gfm", C"Pick git_files scope='modified'",                  "Find modified files")
nmap(L"gfu", C"Pick git_files scope='untracked'",                 "Find untracked files")
nmap(L"go",  C"lua MiniDiff.toggle_overlay()",                    "Toggle diff")
nmap(L"gq",  C"lua require('plugins.mini.diff').to_qf()",         "Quickfix diffs")
nmap(L"mc",  C"lua MiniMap.close()",                              "Close")
nmap(L"mf",  C"lua MiniMap.toggle_focus()",                       "Open")
nmap(L"mr",  C"lua MiniMap.refresh()",                            "Refresh")
nmap(L"ms",  C"lua MiniMap.toggle_side()",                        "Toggle side")
nmap(L"mt",  C"lua MiniMap.toggle()",                             "Toggle map")
nmap(L"Me",  C"lua require('utils').export_minihues_theme()",     "Export MiniHues theme")
nmap(L"Mm",  C"Mason",                                            "Mason")
nmap(L"Ms",  C"lua MiniStarter.open()",                           "Open starter")
nmap(L"Mu",  C"DepsUpdate",                                       "Update deps")
nmap(L"MS",  C"DepsSnapSave",                                     "Save snapshot")
nmap(L"ML",  C"DepsSnapLoad",                                     "Load snapshot")
nmap(L"nN",  C"ZkNewMeeting",                                     "New meeting note")
nmap(L"nb",  C"ZkBacklinks",                                      "Backlink picker")
nmap(L"nd",  C"ZkCd",                                             "Change directory")
nmap(L"nl",  C"ZkLinks",                                          "Link picker")
nmap(L"nm",  C"ZkFullTextSearch",                                 "Search (FTS)")
nmap(L"nn",  C"ZkNew { title = vim.fn.input('Title: ')}",         "New note")
nmap(L"np",  C"ZkPriorMeetings",                                  "Prior meetings")
nmap(L"nr",  C"ZkIndex",                                          "Refresh index")
nmap(L"ns",  C"ZkNotes { sort = { 'created' } }",                 "Search")
nmap(L"nt",  C"ZkTags",                                           "Tags")
nmap(L"ql",  C"lua MiniSessions.select()",                        "Load session")
nmap(L"qq",  C"qa",                                               "Quit all")
nmap(L"qs",  C"lua require('plugins.mini.sessions').save()",      "Save session")
nmap(L's"',  C"Pick registers",                                   "Search registers")
nmap(L"sB",  C"Pick buf_lines scope='all'",                       "Search all buffers")
nmap(L"sC",  C"Pick commands",                                    "Search commands")
nmap(L"sH",  C"Pick hl_groups",                                   "Search highlight groups")
nmap(L"sS",  C"Pick lsp scope='workspace_symbol'",                "Workspace symbol")
nmap(L"sT",  C"Pick treesitter",                                  "Treesitter objects")
nmap(L"sb",  C"Pick buf_lines scope='current'",                   "Search buffer")
nmap(L"sc",  C"Pick history",                                     "Search history")
nmap(L"sd",  C"Pick diagnostic",                                  "Search diagnostics")
nmap(L"sg",  C"Pick grep_live",                                   "Search files")
nmap(L"sh",  C"Pick help",                                        "Search help")
nmap(L"sk",  C"Pick keymaps",                                     "Search keymaps")
nmap(L"so",  C"Pick options",                                     "Search options")
nmap(L"sr",  C"Pick resume",                                      "Resume picker")
nmap(L"ss",  C"Pick lsp scope='document_symbol'",                 "Document symbol")
nmap(L"st",  C"Pick grep pattern='(TODO|FIXME|HACK|NOTE):'",      "Search Todo/Note")
nmap(L"xx",  C"lua vim.diagnostic.setloclist()",                  "Open diagnostic quickfix list")

--stylua: ignore end
