return {
  "echasnovski/mini.hipatterns",
  opts = {
    highlighters = {
      -- Hide passwords
      censor = {
        pattern = "password: ()%S+()",
        group = "",
        extmark_opts = require("util").censor_extmark_opts,
      },
      -- Hex colors
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color({
        style = "inline",
        inline_text = "⬤",
      }),
    },
  },
}
