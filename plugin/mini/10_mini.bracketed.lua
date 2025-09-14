MiniDeps.later(function()
  require("mini.bracketed").setup()

  local suffixes = vim.tbl_map(function(v)
    return v.suffix
  end, vim.tbl_values(MiniBracketed.config))

  -- better mini.bracketed mappings
  local clues = Config.gen_hydra_brackets(suffixes, {
    ["["] = { old = "first", new = "forward" },
    ["]"] = { old = "last", new = "backward" },
  })

  Config.mini_bracketed_clues = clues
end)
