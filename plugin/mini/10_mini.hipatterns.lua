-- ---------------------------------------------------------------------------
-- mini.hipatterns
-- ---------------------------------------------------------------------------

local H = {}

Config.later(function()
  local hipatterns = require("mini.hipatterns")

  hipatterns.setup({
    highlighters = {
      -- Hide passwords
      censor = {
        pattern = "password: ()%S+()",
        group = "",
        extmark_opts = H.censor_extmark_opts,
      },
      -- Hex colors
      hex_color = hipatterns.gen_highlighter.hex_color({
        style = "inline",
        inline_text = " ",
      }),
      -- TODO/FIXME/HACK/NOTE
      -- stylua: ignore start
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
      -- stylua: ignore end
    },
  })

  -- Highlight patterns for highlighting the whole line and hiding colon.
  -- See https://github.com/echasnovski/mini.nvim/discussions/783
  --
  -- Setup two additional hl groups to highlight the entire line while
  -- ensureing a single space is on either side of the keyword as it's
  -- displayed in reverse. To do this requires MiniHipatternsXXXColon and
  -- MiniHipatternsXXXBody. We construct them based on the colors of the
  -- builtin MiniHipatternsXXX.
  local setup_todo_hl_groups = function()
    for _, keyword in ipairs({ "Fixme", "Hack", "Todo", "Note" }) do
      local name = "MiniHipatterns" .. keyword
      local info = Config.get_hl(name) or {}
      local bg = info.bg or (info.reverse and info.fg)
      -- Colon group hides the ":" using same fg and bg
      vim.api.nvim_set_hl(0, name .. "Colon", { fg = bg, bg = bg })
      vim.api.nvim_set_hl(0, name .. "Body", { fg = bg })
    end
  end

  -- Set the heading todo groups AND an autocmd for colorscheme changes.
  setup_todo_hl_groups()
  Config.new_autocmd("Colorscheme", {
    desc = "Setup up todo hl groups for mini.hipatterns.",
    callback = setup_todo_hl_groups,
  })
end)

H.censor_extmark_opts = function(_, match, _)
  local mask = string.rep("x", vim.fn.strchars(match))
  return {
    virt_text = { { mask, "Comment" } },
    virt_text_pos = "overlay",
    priority = 2000,
    right_gravity = false,
  }
end
