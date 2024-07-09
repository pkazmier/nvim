local ai = require("mini.ai")
local extras = require("mini.extra")
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@loop.outer", "@conditional.outer" },
      i = { "@block.inner", "@loop.inner", "@conditional.inner" },
    }),
    B = extras.gen_ai_spec.buffer(),
    D = extras.gen_ai_spec.diagnostic(),
    I = extras.gen_ai_spec.indent(),
    L = extras.gen_ai_spec.line(),
    N = extras.gen_ai_spec.number(),
  },
})
