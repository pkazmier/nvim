local H = {}
local hipatterns = require("mini.hipatterns")

local censor_extmark_opts = function(_, match, _)
  local mask = string.rep("x", vim.fn.strchars(match))
  return {
    virt_text = { { mask, "Comment" } },
    virt_text_pos = "overlay",
    priority = 2000,
    right_gravity = false,
  }
end

require("mini.hipatterns").setup({
  highlighters = {

    -- Hide passwords
    censor = {
      pattern = "password: ()%S+()",
      group = "",
      extmark_opts = censor_extmark_opts,
    },

    -- Hex colors
    hex_color = hipatterns.gen_highlighter.hex_color({
      style = "inline",
      inline_text = "⬤  ",
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

-- Setup custom hipatterns when editing lua/plugins/mini/hues.lua.
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("kaz-minihues-minihipatterns", { clear = true }),
  pattern = { "lua" },
  desc = "Enable additional hipatterns in hues.lua file",
  callback = function(event)
    local name = vim.fn.fnamemodify(event.file, ":t")
    local files = { "hues.lua" }
    if vim.tbl_contains(files, name) and vim.g.colors_name:find("minihues-") then
      local palette = require("mini.hues").make_palette()
      vim.b.minihipatterns_config = H.opts_for_hues_dev(palette)
    end
  end,
})

H.opts_for_hues_dev = function(palette)
  return {
    highlighters = {
      -- Based on folke's tokyonight dev environment
      hl_color = {
        pattern = { "%f[%w]()p%.[%w_%.]+()%f[%W]" },
        group = function(_, match)
          local parts = vim.split(match, ".", { plain = true })
          local color = vim.tbl_get(palette, parts[2])
          return type(color) == "string" and MiniHipatterns.compute_hex_color_group(color, "fg")
        end,
        extmark_opts = function(_, _, data)
          return {
            virt_text = { { "⬤  ", data.hl_group } },
            virt_text_pos = "inline",
            priority = 2000,
          }
        end,
      },
    },
  }
end
