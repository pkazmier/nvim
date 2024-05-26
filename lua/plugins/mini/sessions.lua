local H = {}
local M = {}

require("mini.sessions").setup()

M.save = function()
  local res = H.get_session_from_user("Save session as: ")
  if res ~= nil then
    MiniSessions.write(res)
  end
end

M.delete = function()
  local res = H.get_session_from_user("Delete session: ")
  if res ~= nil then
    MiniSessions.delete(res, { force = true })
  end
end

-- For autocompletion of session name
Config._session_complete = function(arg_lead)
  return vim.tbl_filter(function(x)
    return x:find(arg_lead, 1, true) ~= nil
  end, vim.tbl_keys(MiniSessions.detected))
end

H.get_session_from_user = function(prompt)
  local completion = "customlist,v:lua.Config._session_complete"
  local ok, res = pcall(vim.fn.input, {
    prompt = prompt,
    cancelreturn = false,
    completion = completion,
  })
  if not ok or res == false then
    return nil
  end
  return res
end

return M
