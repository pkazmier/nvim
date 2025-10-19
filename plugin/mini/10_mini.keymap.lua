MiniDeps.later(function()
  require("mini.keymap").setup()

  -- stylua: ignore start
  MiniKeymap.map_multistep("i", "<Tab>",   { "minisnippets_next", "increase_indent", "jump_after_close" })
  MiniKeymap.map_multistep("i", "<S-Tab>", { "minisnippets_prev", "decrease_indent", "jump_before_open" })
  MiniKeymap.map_multistep("i", "<CR>",    { "blink_accept",      "pmenu_accept",    "nvimautopairs_cr" })
  MiniKeymap.map_multistep("i", "<BS>",    { "nvimautopairs_bs" })
  -- stylua: ignore end

  -- Better escape key
  MiniKeymap.map_combo({ "i", "c", "x", "s" }, "jk", "<BS><BS><Esc>")

  -- Prevent bad habits
  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function()
      vim.notify("Too many " .. key)
    end
    MiniKeymap.map_combo({ "n", "x" }, lhs, action)
  end

  notify_many_keys("h")
  notify_many_keys("j")
  notify_many_keys("k")
  notify_many_keys("l")
end)
