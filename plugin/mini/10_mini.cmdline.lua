Config.later(
  function()
    require("mini.cmdline").setup({
      autocomplete = { delay = 200 },
      autopeek = { n_context = 1 },
    })
  end
)
