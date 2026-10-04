-- ---------------------------------------------------------------------------
-- mini.keymap
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.later(function()
  local keymap = require("mini.keymap")
  keymap.setup()

  -- I really like "jump_after_close" when used with an auto pair plugin. It
  -- makes it trivial to skip after the closing quote/bracket/brace/paren.
  -- stylua: ignore start
  keymap.map_multistep("i", "<Tab>",   { "minisnippets_next", "increase_indent", "jump_after_close" })
  keymap.map_multistep("i", "<S-Tab>", { "minisnippets_prev", "decrease_indent", "jump_before_open" })
  keymap.map_multistep("i", "<CR>",    { "pmenu_accept",      "minipairs_cr" })
  keymap.map_multistep("i", "<BS>",    { "minipairs_bs" })
  -- stylua: ignore end

  -- Better escape key
  keymap.map_combo({ "i", "c", "x", "s", "R" }, "jk", "<BS><BS><Esc>")

  -- Prevent bad habits
  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function() vim.notify("Too many " .. key) end
    keymap.map_combo({ "n", "x" }, lhs, action)
  end

  notify_many_keys("h")
  notify_many_keys("j")
  notify_many_keys("k")
  notify_many_keys("l")
end)
