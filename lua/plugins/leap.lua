require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
require("leap.user").set_repeat_keys("<enter>", "<backspace>")

-- I prefer bi-directional searches as the downsides are mostly compensated
-- for by the above set_repeat_keys. I lose dot-repeats, but I'm not using
-- them anyways because I don't want repeat.vim. The other downside is
-- that we don't get as many autojumps, but we'll see how that pans out.
--
-- I had to move mini.surround to gz to make room for this binding.
vim.keymap.set({ "x", "n", "o" }, "s", function()
  require("leap").leap({
    target_windows = { vim.api.nvim_get_current_win() },
  })
end)

-- With bi-directional searching enabled, I use this binding to search other
-- windows. I originally combined them all into one binding to search all
-- windows, but one of leap's benefites is that first autojump, so this helps
-- improve the odds by limiting matches.
vim.keymap.set({ "x", "n", "o" }, "S", function()
  require("leap").leap({
    target_windows = require("leap.util").get_enterable_windows(),
  })
end)

-- I only use remote operations via operating pending mode. This allows me to
-- save wasting another key in my normal mode mappings.
vim.keymap.set({ "o" }, "r", function()
  require("leap.remote").action()
end)

-- This mapping is what LazyVim uses for the built-in treesitter plugin
-- incremental selection, so using it doesn't waste another key in my
-- configuration as I already had this one bound to the same function..
vim.keymap.set({ "n", "x", "o" }, "<C-Space>", function()
  require("leap.treesitter").select()
end)

-- Automatically paste when doing a remote yank operation.
vim.api.nvim_create_augroup("LeapRemote", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "RemoteOperationDone",
  group = "LeapRemote",
  callback = function(event)
    vim.notify(event.data.register)
    -- Do not paste if some special register was in use.
    if vim.v.operator == "y" and event.data.register == "+" then
      vim.cmd("normal! p")
    end
  end,
})
