-- ---------------------------------------------------------------------------
-- render-markdown
-- ---------------------------------------------------------------------------

Config.now_if_args(function()
  vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, { load = true })
  require("render-markdown").setup({
    file_types = { "markdown", "md", "codecompanion" },
    render_modes = { "n", "no", "c", "t", "i", "ic" },
    code = {
      sign = false,
      border = "thin",
      position = "right",
      width = "block",
      above = "▁",
      below = "▔",
      language_left = "█",
      language_right = "█",
      language_border = "▁",
      left_pad = 1,
      right_pad = 1,
    },
    heading = {
      sign = false,
      width = "block",
      left_pad = 1,
      right_pad = 0,
      position = "right",
      icons = function(ctx) return (""):rep(ctx.level) .. "" end,
    },
  })

  -- Setup custom reverse video render-markdown heading hl groups based on
  -- the fg color of existing markdown hl groups. This provides the fancy
  -- headings when in preview mode.
  local setup_heading_hl_groups = function()
    local fallback_hl_info = Config.get_hl("@markup.heading") or Config.get_hl("Title")

    for lvl = 1, 6 do
      local hl_name = "@markup.heading." .. lvl
      local hl_info = Config.get_hl(hl_name .. ".markdown") or Config.get_hl(hl_name) or fallback_hl_info
      assert(
        hl_info,
        "Must set one of 'Title', '@markup.heading', '@markup.heading.N', or '@markup.heading.N.markdown'"
      )

      local hl_spec = {}
      if hl_info.fg then hl_spec.fg = hl_info.fg end
      if hl_info.bg then hl_spec.bg = hl_info.bg end
      if hl_info.bold then hl_spec.bold = true end
      if hl_info.italic then hl_spec.italic = true end

      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. lvl, hl_spec)
      hl_spec.reverse = true
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. lvl .. "Bg", hl_spec)
    end
  end

  -- Set the heading hl groups AND an autocmd for colorscheme changes.
  setup_heading_hl_groups()
  Config.new_autocmd("Colorscheme", {
    desc = "Setup up heading hl groups for render markdown.",
    callback = setup_heading_hl_groups,
  })
end)
