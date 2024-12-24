local M = {}
math.randomseed(os.time())

---Return a random element from the list of choices.
---@param choices any[]
---@return any
M.choose = function(choices)
  return choices[math.random(1, #choices)]
end

return M
