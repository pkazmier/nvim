-- ---------------------------------------------------------------------------
-- mini.keymap
-- ---------------------------------------------------------------------------

Config.later(function()
  require("mini.keymap").setup()

  -- Custom multi-step steps for orgmode: <Tab> / <S-Tab> indent / de-indent the
  -- heading or list item under the cursor in Insert mode (org has no insert-mode
  -- mapping for this). In org terms "demote" deepens a heading (* -> **, visually
  -- indents) and "promote" shallows it -- the same actions bound to >> / << in
  -- Normal mode; on a list item they indent / outdent the item. Gated to those
  -- two structures so ordinary <Tab> behavior (snippets, indent, pair-jumping)
  -- is untouched on plain body text.
  --
  -- do_promote/do_demote modify the buffer, which an expression mapping forbids
  -- (see |MiniKeymap.map_multistep()| notes), so each action RETURNS a function
  -- to be run later as `<Cmd>lua f()<CR>`.
  local function on_org_structure()
    if vim.bo.filetype ~= "org" then return false end
    local line = vim.api.nvim_get_current_line()
    return line:find("^%*+%s") ~= nil -- heading (stars in column 0)
      or line:find("^%s*[-+]%s") ~= nil -- unordered list (- / +, incl. checkboxes)
      or line:find("^%s+%*%s") ~= nil -- unordered list (indented * bullet)
      or line:find("^%s*%d+[.)]%s") ~= nil -- ordered list (1. / 1))
  end

  local function org_mappings() return require("orgmode").instance().org_mappings end

  local orgmode_indent = {
    condition = on_org_structure,
    action = function()
      return function() org_mappings():do_demote() end
    end,
  }

  local orgmode_deindent = {
    condition = on_org_structure,
    action = function()
      return function() org_mappings():do_promote() end
    end,
  }

  -- stylua: ignore start
  -- I really like "jump_after_close" when used with an auto pair plugin. It
  -- makes it trivial to skip after the closing quote/bracket/brace/paren.
  MiniKeymap.map_multistep("i", "<Tab>",   { "minisnippets_next", orgmode_indent,   "increase_indent", "jump_after_close" })
  MiniKeymap.map_multistep("i", "<S-Tab>", { "minisnippets_prev", orgmode_deindent, "decrease_indent", "jump_before_open" })
  MiniKeymap.map_multistep("i", "<CR>",    { "pmenu_accept",      "minipairs_cr" })
  MiniKeymap.map_multistep("i", "<BS>",    { "minipairs_bs" })
  -- stylua: ignore end

  -- Better escape key
  MiniKeymap.map_combo({ "i", "c", "x", "s", "R" }, "jk", "<BS><BS><Esc>")

  -- Prevent bad habits
  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function() vim.notify("Too many " .. key) end
    MiniKeymap.map_combo({ "n", "x" }, lhs, action)
  end

  notify_many_keys("h")
  notify_many_keys("j")
  notify_many_keys("k")
  notify_many_keys("l")
end)
