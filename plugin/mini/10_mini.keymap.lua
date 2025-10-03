MiniDeps.later(function()
  local map_combo = require("mini.keymap").map_combo
  local map_multistep = require("mini.keymap").map_multistep

-- stylua: ignore start
  map_multistep("i", "<Tab>",   { "minisnippets_next", "increase_indent", "jump_after_close" })
  map_multistep("i", "<S-Tab>", { "minisnippets_prev", "decrease_indent", "jump_before_open" })
  map_multistep("i", "<CR>",    { "blink_accept",      "pmenu_accept",    "nvimautopairs_cr" })
  map_multistep("i", "<BS>",    { "nvimautopairs_bs" })
  -- stylua: ignore end

  map_combo({ "i", "c", "x", "s" }, "jk", "<BS><BS><Esc>")

  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function()
      vim.notify("Too many " .. key)
    end
    map_combo({ "n", "x" }, lhs, action)
  end

  notify_many_keys("h")
  notify_many_keys("j")
  notify_many_keys("k")
  notify_many_keys("l")
end)
