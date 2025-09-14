MiniDeps.later(function()
  require("mini.diff").setup()

  Config.minidiff_to_qf = function()
    vim.fn.setqflist(MiniDiff.export("qf"))
    vim.cmd("copen")
  end

  -- better mini.diff 'h/H' mapping
  local clues = Config.gen_hydra_brackets({ "h" }, {
    ["["] = { old = "first", new = "next" },
    ["]"] = { old = "last", new = "prev" },
  })

  Config.mini_diff_clues = clues
end)
