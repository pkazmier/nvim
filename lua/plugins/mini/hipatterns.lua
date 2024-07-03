-- stylua: ignore start
local hipatterns = require("mini.hipatterns")

local censor_extmark_opts = function(_, match, _)
  local mask = string.rep("x", vim.fn.strchars(match))
  return {
    virt_text = { { mask, "Comment" } },
    virt_text_pos = "overlay",
    priority = 200,
    right_gravity = false,
  }
end

require("mini.hipatterns").setup({
  highlighters = {

    -- Hide passwords
    censor = {
      pattern = 'password: ()%S+()',
      group = '',
      extmark_opts = censor_extmark_opts,
    },

    -- Hex colors
    hex_color = hipatterns.gen_highlighter.hex_color(),

    -- TODO/FIXME/HACK/NOTE
    fixme       = { pattern = "() FIXME():",   group = "MiniHipatternsFixme" },
    hack        = { pattern = "() HACK():",    group = "MiniHipatternsHack" },
    todo        = { pattern = "() TODO():",    group = "MiniHipatternsTodo" },
    note        = { pattern = "() NOTE():",    group = "MiniHipatternsNote" },
    fixme_colon = { pattern = " FIXME():()",   group = "MiniHipatternsFixmeColon" },
    hack_colon  = { pattern = " HACK():()",    group = "MiniHipatternsHackColon" },
    todo_colon  = { pattern = " TODO():()",    group = "MiniHipatternsTodoColon" },
    note_colon  = { pattern = " NOTE():()",    group = "MiniHipatternsNoteColon" },
    fixme_body  = { pattern = " FIXME:().*()", group = "MiniHipatternsFixmeBody" },
    hack_body   = { pattern = " HACK:().*()",  group = "MiniHipatternsHackBody" },
    todo_body   = { pattern = " TODO:().*()",  group = "MiniHipatternsTodoBody" },
    note_body   = { pattern = " NOTE:().*()",  group = "MiniHipatternsNoteBody" },
  },
})
-- stylua: ignore end
