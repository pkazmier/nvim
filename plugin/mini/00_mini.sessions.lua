local H = {}
MiniDeps.now(function()
  require("mini.sessions").setup()

  Config.session_save = function()
    local res = H.session_prompt("Save session as: ")
    if res ~= nil then
      MiniSessions.write(res)
    end
  end

  Config.session_delete = function()
    local res = H.session_prompt("Delete session: ")
    if res ~= nil then
      MiniSessions.delete(res, { force = true })
    end
  end

  -- For autocompletion of session name
  Config.session_complete = function(arg_lead)
    return vim.tbl_filter(function(x)
      return x:find(arg_lead, 1, true) ~= nil
    end, vim.tbl_keys(MiniSessions.detected))
  end

  H.session_prompt = function(prompt)
    local completion = "customlist,v:lua.Config.session_complete"
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
end)
