local M = {}
local H = {}

M.icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
}

M.export_minihues_theme = function()
  local ok, theme_name = pcall(vim.fn.input, {
    prompt = "Enter name for color scheme: minihues-",
    cancelreturn = false,
  })
  if not ok or theme_name == false then
    return nil
  end
  theme_name = "minihues-" .. theme_name
  local p = require("mini.hues").make_palette({})
  H.render(H.minihues_path(theme_name), H.minihues_template, theme_name, vim.inspect(H.minihues_opts(p)))
  vim.cmd("split")
  H.render(H.wezterm_path(theme_name), H.wezterm_template, theme_name, vim.inspect(H.wezterm_opts(p)))
end

H.wezterm_path = function(theme_name)
  local dir = os.getenv("WEZTERM_CONFIG_DIR")
  return string.format("%s/color-%s.lua", dir, theme_name)
end

H.minihues_path = function(theme_name)
  local dir = string.format("~/.config/%s/colors", os.getenv("NVIM_APPNAME"))
  return string.format("%s/%s.lua", dir, theme_name)
end

H.render = function(filename, template, ...)
  local rendered = string.format(template, ...)
  vim.cmd(string.format("edit %s", filename))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(rendered, "\n"))
end

H.minihues_template = [[local hues = require("mini.hues")
vim.g.colors_name = "%s"
local opts = %s
hues.setup(opts)
require("plugins.mini.hues").apply_custom_highlights(opts)
]]

H.wezterm_template = [[local M = {}
local name = "%s"

M.activate = function(config, opts)
  config.color_scheme = name
end

M.init = function(config, opts)
  config.color_schemes = config.color_schemes or {}
  config.color_schemes[name] = %s
end

return M
]]

H.minihues_opts = function(p)
  return {
    background = p.bg,
    foreground = p.fg,
    accent = "azure",
  }
end

H.wezterm_opts = function(p)
  return {
    foreground = p.fg,
    background = p.bg,
    cursor_bg = p.azure,
    cursor_fg = p.azure_bg,
    cursor_border = p.azure,
    selection_bg = p.bg_mid2,
    scrollbar_thumb = p.bg_mid,
    split = p.bg_mid2,
    ansi = {
      p.bg,
      p.red,
      p.green,
      p.yellow,
      p.azure,
      p.purple,
      p.cyan,
      p.fg,
    },
    brights = {
      p.bg_mid,
      p.red,
      p.green,
      p.yellow,
      p.azure,
      p.purple,
      p.cyan,
      p.fg_mid,
    },
    indexed = { [136] = p.orange },
    compose_cursor = p.orange,
    copy_mode_active_highlight_bg = { Color = p.bg },
    copy_mode_active_highlight_fg = { Color = p.fg_mid },
    copy_mode_inactive_highlight_bg = { Color = p.green },
    copy_mode_inactive_highlight_fg = { Color = p.bg },
    quick_select_label_fg = { Color = p.bg },
    quick_select_label_bg = { Color = p.orange },
    quick_select_match_bg = { Color = p.bg_mid },
    quick_select_match_fg = { Color = p.azure },
  }
end

return M
