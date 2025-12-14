local H = {}

-- ---------------------------------------------------------------------------
-- Debug Utils
-- ---------------------------------------------------------------------------

Config.dd = function(...)
  vim.notify(vim.iter({ ... }):map(vim.inspect):join(", "))
end

-- ---------------------------------------------------------------------------
-- Lazy Loading Helper
-- ---------------------------------------------------------------------------

Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later

-- ---------------------------------------------------------------------------
-- Custom `vim.pack.add()` hook helper
-- ---------------------------------------------------------------------------

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end

-- ---------------------------------------------------------------------------
-- Scratch Buffer
-- ---------------------------------------------------------------------------

-- Open a new scratch buffer in the current window. This differs from
-- `:enew` in that it creates a new empty buffer rather than reusing
-- the existing empty buffer if one exists. It also sets the buffer to
-- be a scratch buffer (i.e. not listed, not saved to disk).
Config.new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

-- ---------------------------------------------------------------------------
-- Re-map Binding
-- ---------------------------------------------------------------------------

Config.remap = function(mode, lhs_from, lhs_to)
  local keymap = vim.fn.maparg(lhs_from, mode, false, true)
  local rhs = keymap.callback or keymap.rhs
  if rhs == nil then
    error("Could not remap from " .. lhs_from .. " to " .. lhs_to)
  end
  vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
end

-- ---------------------------------------------------------------------------
-- Hydra Brackets
-- ---------------------------------------------------------------------------

-- Generate keymaps for bracketed navigation tuned for repeated motions. For
-- example, mini.bracketed defines the following mappings to navigate between
-- diagnostics:
--
--   [D : go to first diagnostic
--   ]D : go to last diagnostic
--   [d : go to previous diagnostic
--   ]d : go to next diagnostic
--
-- With this setup, if one wanted to move forward three diagnostics and then
-- back one, it would require the following keypresses: ]d]d]d[d. This is
-- a bit cumbersome for me as a Dvorak user due to placement of [ and ] in
-- the number row.
--
-- We could take advantage af postkey in mini.clue to eliminate the need for
-- repeated keypresses of the the brackets. In that case, the above example
-- would be ]ddd<C-c>[d<C-c>. However, this still requires the user to switch
-- back and forth between the left and right brackets when changing direction.
--
-- To make this more efficient, we can remap the uppercase versions of the
-- suffixes to navigate in the opposite direction. This way, the user can stay
-- on one side of the keyboard when changing direction. The above example
-- would then be ]ddD<C-c>. This is much more efficient for my typing style.
--
-- This function returns the clues for mini.clue and sets the mappings to
-- achieve this. I use it twice in my config to change the mini.bracketed
-- mappings as well as goto-hunk mappings from mini.diff.
--
-- Let's look at an example to see how this function achieves the above. By
-- default, after mini.bracketed.setup() has been called, mappings have been
-- established in the form of for many suffixes (I'm only showing 'd' here):
--
--     vim.keymap.set("n", "[D", "<Cmd>lua MiniBracketed.diagnostic('first')<Cr>",    { desc = "Diagnostic first" })
--     vim.keymap.set("n", "[d", "<Cmd>lua MiniBracketed.diagnostic('backward')<Cr>", { desc = "Diagnostic backward" })
--     vim.keymap.set("n", "]D", "<Cmd>lua MiniBracketed.diagnostic('last')<Cr>",     { desc = "Diagnostic last" })
--     vim.keymap.set("n", "]d", "<Cmd>lua MiniBracketed.diagnostic('forward')<Cr>",  { desc = "Diagnostic forward" })
--
-- If we want to change those diagnostic mappings, then we can call this
-- function with the following arguments (suffixes should be lowercase):
--
--     local clues = Config.gen_hydra_brackets({ "d" }, {
--       ["["] = { old = "first", new = "forward" },
--       ["]"] = { old = "last", new = "backward" },
--     })
--
-- It returns the following clues, which use postkeys in the mini.clue spec.
--
--       { { keys = "[d", mode = "n", postkeys = "[", },
--         { keys = "[D", mode = "n", postkeys = "[", },
--         { keys = "]d", mode = "n", postkeys = "]", },
--         { keys = "]D", mode = "n", postkeys = "]", } }
--
-- It then updates the mappings that were created by mini.bracketed to the
-- following (changes in uppercase):
--
--     vim.keymap.set("n", "[D", "<Cmd>lua MiniBracketed.diagnostic('FORWARD')<Cr>",  { desc = "Diagnostic FORWARD" })
--     vim.keymap.set("n", "]D", "<Cmd>lua MiniBracketed.diagnostic('BACKWARD')<Cr>", { desc = "Diagnostic BACKWARD" })
--
-- This function can only work with a string-based RHS such as those defined
-- by mini.bracketed and mini.diff. The list of suffixes passed should be the
-- lowercase variants of the movement key ('d' instead of 'D' for example).
Config.gen_hydra_brackets = function(suffixes, replacements)
  local clues = {}
  for _, suffix in ipairs(suffixes) do
    local lower_suffix = suffix
    local upper_suffix = suffix:upper()

    for bracket, pattern in pairs(replacements) do
      -- Use hydra mode for all bracketed targets
      table.insert(clues, { mode = "n", keys = bracket .. lower_suffix, postkeys = bracket })
      table.insert(clues, { mode = "n", keys = bracket .. upper_suffix, postkeys = bracket })

      -- Make uppercase navigate in other direction instead of first/last
      local map = vim.fn.maparg(bracket .. upper_suffix, "n", false, true)
      local new_rhs = map.rhs:gsub(pattern.old, pattern.new)
      local new_desc = map.desc
      new_desc = new_desc:gsub(pattern.old, pattern.new)
      new_desc = new_desc:gsub(H.capitalize(pattern.old), H.capitalize(pattern.new))
      vim.keymap.set("n", bracket .. upper_suffix, new_rhs, { desc = new_desc })
    end
  end
  return clues
end

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Return a string where the first letter has been capitalized.
H.capitalize = function(w)
  return w:sub(1, 1):upper() .. w:sub(2)
end
