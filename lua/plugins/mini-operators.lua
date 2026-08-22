-- ---------------------------------------------------------------------------
-- mini.operators
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local functions = require("config.functions")

loader.later(function()
  functions.remap("n", "gx", "gX")
  functions.remap("x", "gx", "gX")

  local clue = require("mini.clue")
  clue.set_mapping_desc("n", "gX", "Open file or URI")
  clue.set_mapping_desc("x", "gX", "Open file or URI")

  -- From https://github.com/echasnovski/mini.nvim/discussions/1835
  local comment_multiply = false
  local my_multiply_func = function(content)
    if not (comment_multiply and content.submode == "V") then return content.lines end

    -- Add comment
    comment_multiply = false
    local commentstring = vim.bo.commentstring
    return vim.tbl_map(function(l) return (commentstring:gsub("%%s", l)) end, content.lines)
  end
  require("mini.operators").setup({ multiply = { func = my_multiply_func } })

  local map_comment_multiply = function(mode, lhs, multiply_keys, desc)
    local rhs = function()
      -- Preserve cursor position so that it is on *not* commented part
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.schedule(function() vim.api.nvim_win_set_cursor(0, pos) end)

      comment_multiply = true
      return multiply_keys
    end

    vim.keymap.set(mode, lhs, rhs, { expr = true, remap = true, desc = desc })
  end

  map_comment_multiply({ "n", "x" }, "gC", "gm", "Multiply and comment")
  map_comment_multiply("n", "gCC", "gmm", "Multiply and comment line")
end)
