vim.bo.commentstring = ";; %s"

-- Customize 'mini.splitjoin' for lisp syntax: arguments are separated by
-- whitespace instead of commas, and brackets stay glued to the first/last
-- arguments instead of moving onto their own lines:
--
--   {:a 1 :b 2}         <->  {:a 1        [:one :two :three]  <->  [:one
--                             :b 2}                                 :two
--                                                                   :three]
--
-- `{}` tables and `let` binding vectors split one PAIR per line; other `[]`
-- sequences split one element per line. `()` forms are left alone.
--
-- NOTE: keep in sync with after/ftplugin/fennel.fnl on the `fennel` branch,
-- which supersedes this file once the migration lands.

-- Opening bracket of the split in progress, stashed by the pre-hook so the
-- post-hook can align continuation lines under it.
local bracket = nil

local pairwise = function(line, col)
  -- `{}` tables hold key/value pairs; so does a `[` directly preceded by
  -- `let` on the same line (its binding vector). The `%f[%w]` frontier
  -- rejects identifiers merely ending in "let".
  local char = line:sub(col, col)
  if char == "{" then return true end
  return char == "[" and line:sub(1, col - 1):match("%f[%w]let%s*$") ~= nil
end

local split_positions = function(positions)
  -- Input positions: opening bracket, inner separators..., closing bracket.
  -- Drop both brackets so they stay glued to their arguments, and for
  -- pair-wise regions keep every SECOND separator so pairs stay together.
  local first = positions[1]
  local line = vim.fn.getline(first.line)
  local step = pairwise(line, first.col) and 2 or 1
  local kept = {}
  bracket = first
  for i = 1 + step, #positions - 1, step do
    table.insert(kept, positions[i])
  end
  return kept
end

local split_reindent = function(positions)
  -- `split_at` indents continuation lines by shiftwidth; re-indent them to
  -- align under the first argument instead. The last input position sits on
  -- the region's final line (appended by 'mini.splitjoin' for hook use).
  if bracket ~= nil then
    local line = vim.fn.getline(bracket.line)
    local indent = string.rep(" ", vim.fn.strdisplaywidth(line:sub(1, bracket.col)))
    local last = positions[#positions]
    for lnum = bracket.line + 1, last.line do
      local old = vim.fn.getline(lnum):match("^%s*")
      vim.api.nvim_buf_set_text(0, lnum - 1, 0, lnum - 1, old:len(), { indent })
    end
    bracket = nil
  end
  return positions
end

local join_seam_cols = function(positions)
  -- Seam positions sit on each line's LAST character. If that is trailing
  -- whitespace, `join_at` deletes it and the extmark tracking the seam
  -- drifts onto the next line's first character, making `join_pad` below
  -- pad the wrong side of it. Move seams onto the last non-blank character.
  for _, pos in ipairs(positions) do
    local rstripped = vim.fn.getline(pos.line):gsub("%s+$", "")
    pos.col = math.max(rstripped:len(), 1)
  end
  return positions
end

local join_pad = function(positions)
  -- `join_at` pads inner seams with a space but the first and last seams
  -- with nothing (it assumes brackets sat on their own lines); with glued
  -- brackets those seams separate arguments, so pad them too. The last
  -- input position is not a seam (appended by 'mini.splitjoin') -- skip it.
  local pad = function(pos)
    vim.api.nvim_buf_set_text(0, pos.line - 1, pos.col, pos.line - 1, pos.col, { " " })
  end
  local seams = #positions - 1
  if seams >= 1 then pad(positions[seams]) end
  if seams >= 2 then pad(positions[1]) end
  return positions
end

vim.b.minisplitjoin_config = {
  detect = {
    -- No `%b()`: splitting code forms one-arg-per-line is rarely what you
    -- want in a lisp
    brackets = { "%b{}", "%b[]" },
    separator = "%s+",
    -- Default minus `%b''`: single quote is Fennel's quote shorthand, not a
    -- string delimiter
    exclude_regions = { "%b()", "%b[]", "%b{}", '%b""' },
  },
  split = { hooks_pre = { split_positions }, hooks_post = { split_reindent } },
  join = { hooks_pre = { join_seam_cols }, hooks_post = { join_pad } },
}
