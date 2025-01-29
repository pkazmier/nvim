local M = {}
math.randomseed(os.time())

---Return a random element from the list of choices.
---@param choices any[]
---@return any
M.choose = function(choices)
  return choices[math.random(1, #choices)]
end

M.censor_extmark_opts = function(_, match, _)
  local mask = string.rep("x", vim.fn.strchars(match))
  return {
    virt_text = { { mask, "Comment" } },
    virt_text_pos = "overlay",
    priority = 2000,
    right_gravity = false,
  }
end

return M
