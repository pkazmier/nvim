MiniDeps.now(function()
  require("mini.basics").setup({
    options = { extra_ui = false, win_borders = "bold" },
    mappings = { windows = true, move_with_alt = true },
    autocommands = { relnum_in_visual_mode = true },
  })
end)
