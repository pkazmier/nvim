-- stylua: ignore start

local M = {}

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
local E = function(plugin, func) return C("lua require('" .. plugin .. "')." .. func) end

-- ---------------------------------------------------------------------------
-- Leader Groups
-- ---------------------------------------------------------------------------

-- Leader mappings and descriptions, exported at the bottom of this module
-- for mini.clue's setup (plugins/mini-clue.lua requires us).
M.leader_group_clues = {
  { mode = "n",        keys = L"b",  desc = "+Buffer" },
  { mode = {"n", "x"}, keys = L"c",  desc = "+Copilot" },
  { mode = "n",        keys = L"e",  desc = "+Explore" },
  { mode = "n",        keys = L"f",  desc = "+Find" },
  { mode = {"n", "x"}, keys = L"g",  desc = "+Git" },
  { mode = {"n", "x"}, keys = L"l",  desc = "+Language" },
  { mode = "n",        keys = L"m",  desc = "+Map" },
  { mode = "n",        keys = L"o",  desc = "+Org" },
  { mode = "n",        keys = L"O",  desc = "+Other" },
  { mode = "n",        keys = L"s",  desc = "+Session" },
  { mode = "n",        keys = L"v",  desc = "+Visits" },
  { mode = "n",        keys = L"w",  desc = "+Window" },
}

-- ---------------------------------------------------------------------------
-- Basic Mappings
-- ---------------------------------------------------------------------------

map("i",   "<A-Space>", C"normal ciw",                                         "Just one space")
map("n",   "-",         C"Oil",                                                "Open Oil")
map("n",   "H",         C"lua MiniBracketed.buffer('backward')",               "Prev buffer")
map("n",   "L",         C"lua MiniBracketed.buffer('forward')",                "Next buffer")
map("n",   "z=",        C"Pick spellsuggest",                                  "Spelling suggestions")
map("n",   "[p",        C"exe 'iput! ' . v:register",                          "Paste above")
map("n",   "]p",        C"exe 'iput ' . v:register",                           "Paste below")
map("n",   [[\f]],      E("plugins.conform", "toggle()"),                      "Toggle auto-format")
map("n",   [[\H]],      E("plugins.lsp", "toggle_hints()"),                    "Toggle inlay hints")
map("n",   [[\W]],      E("plugins.mini-cursorword", "toggle()"),              "Toggle cursor word")
map("nxo", "sj",        "<Plug>(leap)",                                        "Leap anywhere")
map("nxo", "S",         E("leap.treesitter", "select()"),                      "Treesitter select")

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
map("n",   L"bp",       E("plugins.mini-tabline", "toggle_pinned()"),          "Pin buffer")
map("n",   L"bP",       E("plugins.mini-tabline", "remove_pinned('delete')"),  "Delete non-pinned")
map("n",   L"bs",       E("config.functions", "new_scratch_buffer()"),         "New scratch buffer")
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

map("n",   L"ec",       C"Pick config",                                        "Pick config file")
map("n",   L"ed",       C"lua MiniFiles.open()",                               "Directory (cwd)")
map("n",   L"ef",       E("plugins.mini-files", "open_bufdir()"),              "Directory (file)")
map("n",   L"el",       E("quicker", "toggle({ loclist = true })"),            "Location list")
map("n",   L"en",       C"lua MiniNotify.show_history()",                      "Notification history")
map("n",   L"ep",       C"Pick plugins",                                       "Pick plugin")
map("n",   L"eq",       E("quicker", "toggle()"),                              "Quickfix toggle")
map("n",   L"er",       C"Pick projects",                                      "Pick projects")
map("n",   L"eu",       C"Undotree",                                           "Open undotree")

-- ---------------------------------------------------------------------------
-- Find
-- ---------------------------------------------------------------------------

map("n",   L"f/",       C"Pick history scope='/'",                             "'/' history")
map("n",   L"f:",       C"Pick history scope=':'",                             "':' history")
map("n",   L"fa",       C"Pick git_hunks scope='staged'",                      "Added hunks (all)")
map("n",   L"fA",       C"Pick git_hunks path='%' scope='staged'",             "Added hunks (buf)")
map("n",   L"fb",       C"Pick buffers",                                       "Pick buffer")
map("n",   L"fc",       C"Pick git_commits",                                   "Commits (all)")
map("n",   L"fC",       C"Pick git_commits path='%'",                          "Commits (buf)")
map("n",   L"fd",       C"Pick diagnostic scope='all'",                        "Diagnostic (workspace)")
map("n",   L"fD",       C"Pick diagnostic scope='current'",                    "Diagnostic (buf)")
map("n",   L"ff",       C"Pick files",                                         "Pick file")
map("n",   L"fg",       C"Pick grep_live_align",                               "Grep live")
map("n",   L"fG",       C"Pick grep_align pattern='<cword>'",                  "Grep current word")
map("n",   L"fh",       C"Pick help",                                          "Help tags")
map("n",   L"fH",       C"Pick hl_groups",                                     "Highlight groups")
map("n",   L"fk",       C"Pick keymaps",                                       "Keymaps")
map("n",   L"fl",       C"Pick buf_lines scope='all' preserve_order=true",     "Lines (all)")
map("n",   L"fL",       C"Pick buf_lines scope='current' preserve_order=true", "Lines (buf)")
map("n",   L"fm",       C"Pick git_hunks",                                     "Modified hunks (all)")
map("n",   L"fM",       C"Pick git_hunks path='%'",                            "Modified hunks (buf)")
map("n",   L"fr",       C"Pick resume",                                        "Resume picker")
map("n",   L"fR",       C"Pick lsp_align scope='references'",                  "References (LSP)")
map("n",   L"fs",       C"Pick lsp_align scope='workspace_symbol'",            "Symbols workspace")
map("n",   L"fS",       C"Pick lsp_align scope='document_symbol'",             "Symbols document")
map("n",   L"ft",       C"Pick grep_todo_keywords",                            "Search todo/fixme/hack")
map("n",   L"fT",       C"Pick colorschemes",                                  "Choose colorscheme")
map("n",   L"fv",       C"Pick visit_paths cwd=''",                            "Visit paths (all)")
map("n",   L"fV",       C"Pick visit_paths",                                   "Visit paths (cwd)")

-- ---------------------------------------------------------------------------
-- Git
-- ---------------------------------------------------------------------------

map("n",   L"ga",       C"Git diff --cached",                                  "Added diff")
map("n",   L"gA",       C"Git diff --cached -- %",                             "Added diff (buf)")
map("nx",  L"gb",       C"lua MiniGit.show_range_history()",                   "Range history")
map("n",   L"gc",       C"Git commit",                                         "Commit ")
map("n",   L"gC",       C"Git commit --amend",                                 "Commit amend")
map("n",   L"gd",       C"Git diff",                                           "Git diff")
map("n",   L"gD",       C"Git diff -- %",                                      "Git diff (buf)")
map("n",   L"gg",       E("plugins.toggleterm", "lazygit()"),                  "Toggle Lazygit")
map("n",   L"gl",       E("plugins.mini-git", "log()"),                        "Git log")
map("n",   L"gL",       E("plugins.mini-git", "log_buf()"),                    "Git log (buf)")
map("n",   L"go",       C"lua MiniDiff.toggle_overlay()",                      "Toggle overlay")
map("n",   L"gq",       E("plugins.mini-diff", "to_qf()"),                     "Quickfix diffs")
map("nx",  L"gs",       C"lua MiniGit.show_at_cursor()",                       "Show at cursor")

-- ---------------------------------------------------------------------------
-- Language
-- ---------------------------------------------------------------------------

map("nx",  L"la",       C"lua vim.lsp.buf.code_action()",                      "Code actions")
map("n",   L"ld",       C"lua vim.diagnostic.open_float()",                    "Diagnostic popup")
map("nx",  L"lf",       E("conform", "format()"),                              "Format buffer")
map("n",   L"li",       C"lua vim.lsp.buf.implementation()",                   "LSP Implementation")
map("n",   L"lI",       C"LspInfo",                                            "LSP info")
map("n",   L"lh",       C"lua vim.lsp.buf.hover()",                            "LSP Hover")
map("n",   L"ll",       C"lua vim.lsp.codelens.run()",                         "Run codelens")
map("n",   L"lL",       C"lua vim.lsp.codelens.refresh()",                     "Refresh & display codelens")
map("n",   L"lr",       C"lua vim.lsp.buf.rename()",                           "LSP Rename")
map("n",   L"lR",       C"lua vim.lsp.buf.references()",                       "LSP References")
map("n",   L"ls",       C"lua vim.lsp.buf.definition()",                       "Source definition")
map("n",   L"lt",       C"lua vim.lsp.buf.type_definition()",                  "Type definition")

-- ---------------------------------------------------------------------------
-- Map
-- ---------------------------------------------------------------------------

map("n",   L"mf",       C"lua MiniMap.toggle_focus()",                         "Focus map")
map("n",   L"mr",       C"lua MiniMap.refresh()",                              "Refresh map")
map("n",   L"ms",       C"lua MiniMap.toggle_side()",                          "Switch sides")
map("n",   L"mt",       E("plugins.mini-map", "toggle()"),                     "Toggle map")
map("n",   L"mT",       E("plugins.mini-map", "buf_toggle()"),                 "Toggle map (buf)")

-- ---------------------------------------------------------------------------
-- Org
-- ---------------------------------------------------------------------------

map("n",   L"of",       E("plugins.orgmode", "files()"),                       "Open org file")
map("n",   L"oh",       E("plugins.orgmode", "headlines()"),                   "Search headlines")
map("n",   L"om",       E("plugins.orgmode", "new_meeting_entry()"),           "New meeting entry")
map("n",   L"o/",       E("plugins.orgmode", "grep()"),                        "Grep all lines")

-- ---------------------------------------------------------------------------
-- Other
-- ---------------------------------------------------------------------------

map("n",   L"Oa",       C"Mason",                                              "Open Mason")
map("n",   L"Os",       C"lua MiniStarter.open()",                             "Open MiniStarter")
map("n",   L"Ou",       C"lua vim.pack.update()",                              "Update plugins")

-- ---------------------------------------------------------------------------
-- Session
-- ---------------------------------------------------------------------------

map("n",   L"sd",       C"lua MiniSessions.select('delete')",                  "Delete session")
map("n",   L"sl",       C"lua MiniSessions.select('read')",                    "Load session")
map("n",   L"sn",       C"lua MiniSessions.write(vim.fn.input('Name: '))",     "New session")
map("n",   L"sr",       C"lua MiniSessions.restart()",                         "Restart session")
map("n",   L"ss",       C"lua MiniSessions.write()",                           "Save session")

-- ---------------------------------------------------------------------------
-- Visits
-- ---------------------------------------------------------------------------

map("n",   L"va",       C"Pick visit_labels cwd=''",                           "All labels")
map("n",   L"vc",       E("plugins.mini-visits", "pick('','core')"),           "Core visits (all)")
map("n",   L"vC",       E("plugins.mini-visits", "pick(nil,'core')"),          "Core visits (cwd)")
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

return M
