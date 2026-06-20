-- ---------------------------------------------------------------------------
-- mini.keymap
-- ---------------------------------------------------------------------------

Config.later(function()
  require("mini.keymap").setup()

  -- Org <Tab>/<S-Tab> steps: indent / de-indent the heading or list item under
  -- the cursor in Insert mode (org has no insert mapping for this; demote/promote
  -- are >> / << in Normal mode). Gated to org headings/list lines so ordinary
  local function on_org_structure()
    if vim.bo.filetype ~= "org" then return false end
    local line = vim.api.nvim_get_current_line()
    return line:find("^%*+%s") ~= nil -- heading (stars in column 0)
      or line:find("^%s*[-+]%s") ~= nil -- unordered list (- / +, incl. checkboxes)
      or line:find("^%s+%*%s") ~= nil -- unordered list (indented * bullet)
      or line:find("^%s*%d+[.)]%s") ~= nil -- ordered list (1. / 1))
  end

  -- After demote/promote, shift the cursor by the line-length change: org restores
  -- the ORIGINAL column (winrestview) while the added/removed stars shift the text,
  -- stranding the cursor among the stars after repeated <Tab>. Capture the cursor
  -- BEFORE -- promote shortens the line and winrestview clamps a near-end cursor,
  -- so reading it back would over-shift past the space.
  local function indent_step(method)
    return {
      condition = on_org_structure,
      action = function()
        return function()
          local om = require("orgmode").instance().org_mappings
          local cur = vim.api.nvim_win_get_cursor(0)
          local before = #vim.api.nvim_get_current_line()
          om[method](om)
          local delta = #vim.api.nvim_get_current_line() - before
          if delta ~= 0 then vim.api.nvim_win_set_cursor(0, { cur[1], math.max(0, cur[2] + delta) }) end
        end
      end,
    }
  end

  -- Org tables: <Tab>/<S-Tab> move between cells (org itself has no cell motion
  -- -- its <Tab>/<S-Tab> are fold cycling). <Tab> on the last cell starts a new
  -- row. Gated to '|' rows, so outside a table it falls through to the indent
  -- steps. The cell movers live on Config (plugin/other/10_orgmode.lua, loaded
  -- AFTER this file), so look them up by name at keypress time, not at setup.
  local function table_cell(fn)
    return {
      condition = function() return vim.bo.filetype == "org" and vim.api.nvim_get_current_line():find("^%s*|") ~= nil end,
      action = function() return Config[fn] end,
    }
  end

  -- I really like "jump_after_close" when used with an auto pair plugin. It
  -- makes it trivial to skip after the closing quote/bracket/brace/paren.
  -- stylua: ignore start
  MiniKeymap.map_multistep("i", "<Tab>",   { "minisnippets_next", table_cell("org_table_next_cell"), indent_step("do_demote"),  "increase_indent", "jump_after_close" })
  MiniKeymap.map_multistep("i", "<S-Tab>", { "minisnippets_prev", table_cell("org_table_prev_cell"), indent_step("do_promote"), "decrease_indent", "jump_before_open" })
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
