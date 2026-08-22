vim.api.nvim_buf_set_keymap(0, "i", "<M-i>", " = ", { noremap = true })

-- Use custom comment leaders to allow both nested variants (`--` and `----`)
-- and "docgen" variant (`---`).
vim.opt_local.comments = { ":---", ":--" }

-- Customize 'mini.nvim'
vim.b.miniai_config = {
  custom_textobjects = {
    S = { "%[%[().-()%]%]" },
  },
}

local mini_splitjoin = require("mini.splitjoin")
local gen_hook = mini_splitjoin.gen_hook
local curly = { brackets = { "%b{}" } }

-- Add trailing comma when splitting inside curly brackets
local add_comma_curly = gen_hook.add_trailing_separator(curly)

-- Delete trailing comma when joining inside curly brackets
local del_comma_curly = gen_hook.del_trailing_separator(curly)

-- Pad curly brackets with single space after join
local pad_curly = gen_hook.pad_brackets(curly)

vim.b.minisplitjoin_config = {
  split = { hooks_post = { add_comma_curly } },
  join = { hooks_post = { del_comma_curly, pad_curly } },
}

vim.b.minisurround_config = {
  custom_surroundings = {
    s = { input = { "%[%[().-()%]%]" }, output = { left = "[[", right = "]]" } },
  },
}

local mini_snippets = require("mini.snippets")
local match = function(snippets) return mini_snippets.default_match(snippets, { pattern_fuzzy = "[%w@_]*" }) end
vim.b.minisnippets_config = { expand = { match = match } }
