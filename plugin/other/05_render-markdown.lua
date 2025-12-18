-- ---------------------------------------------------------------------------
-- render-markdown
-- ---------------------------------------------------------------------------

local get_hl = function(hl_name)
  local hl_info = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
  return not vim.tbl_isempty(hl_info) and hl_info or nil
end

local setup_heading_hl_groups = function()
  local fallback_hl_info = get_hl("@markup.heading") or get_hl("Title")

  for lvl = 1, 6 do
    local hl_info = get_hl("@markup.heading." .. lvl .. ".markdown")
      or get_hl("@markup.heading." .. lvl)
      or fallback_hl_info
    assert(hl_info, "Must set one of 'Title', '@markup.heading', '@markup.heading.N', or '@markup.heading.N.markdown'")

    local hl_spec = { fg = hl_info.fg, bg = hl_info.bg, bold = hl_info.bold, italic = hl_info.italic }
    vim.api.nvim_set_hl(0, "RenderMarkdownH" .. lvl, hl_spec)
    hl_spec.reverse = true
    vim.api.nvim_set_hl(0, "RenderMarkdownH" .. lvl .. "Bg", hl_spec)
  end
end

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

  -- Set the heading hl groups as well as an autocmd for colorscheme changes.
  setup_heading_hl_groups()
  Config.new_autocmd("Colorscheme", {
    desc = "Setup up heading hl groups for render markdown.",
    callback = setup_heading_hl_groups,
  })
end)
