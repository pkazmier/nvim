vim.opt_local.wrap = true
vim.opt_local.spell = true

local mini_ai = require("mini.ai")
vim.b.miniai_config = {
  custom_textobjects = {
    S = { "```().-()```" },
    ["*"] = mini_ai.gen_spec.pair("*", "*", { type = "greedy" }),
    ["_"] = mini_ai.gen_spec.pair("_", "_", { type = "greedy" }),
  },
}

local mini_surround = require("mini.surround")
vim.b.minisurround_config = {
  custom_surroundings = {
    -- Bold
    B = { input = { "%*%*().-()%*%*" }, output = { left = "**", right = "**" } },

    -- Link
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = mini_surround.user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}
