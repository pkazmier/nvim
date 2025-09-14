MiniDeps.later(function()
  local ai = require("mini.ai")
  local extra = require("mini.extra")
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@loop.outer", "@conditional.outer" },
        i = { "@block.inner", "@loop.inner", "@conditional.inner" },
      }),
      B = extra.gen_ai_spec.buffer(),
      D = extra.gen_ai_spec.diagnostic(),
      I = extra.gen_ai_spec.indent(),
      L = extra.gen_ai_spec.line(),
      N = extra.gen_ai_spec.number(),
    },
  })
end)
