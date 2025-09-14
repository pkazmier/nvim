local H = {}

-- Debug print
Config.dd = function(...)
  vim.notify(vim.inspect(...))
end

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
-- This function generates the necessary clues and remaps to achieve this.
-- I use it twice in my config to change all of the mini.bracketed mappings
-- as well as goto-hunk mappings from mini.diff.
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

H.capitalize = function(w)
  return w:sub(1, 1):upper() .. w:sub(2)
end
