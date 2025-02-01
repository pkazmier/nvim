local M = {}

-- Enhance picker with concept of preferred pickers. This allows one to set
-- the default picker and a binding that will cycle through a set of other
-- pickers. See my snacks.picker config in plugins/ui.lua where I use these.
local layouts = require("snacks.picker.config.layouts")

layouts.ivy_taller = vim.tbl_deep_extend("keep", { layout = { height = 0.8 } }, layouts.ivy)

layouts.ivy_wider_results = vim.deepcopy(layouts.ivy)
layouts.ivy_wider_results.layout[2][2].width = 0.1

layouts.ivy_wider_preview = vim.deepcopy(layouts.ivy)
layouts.ivy_wider_preview.layout[2][2].width = 0.9

local idx = 1
local preferred = {
  "ivy",
  "ivy_wider_results",
  "ivy_wider_preview",
  "ivy_taller",
}

M.preferred_layout = function()
  return preferred[idx]
end

M.set_next_preferred_layout = function(picker)
  idx = idx % #preferred + 1
  picker:set_layout(preferred[idx])
end

-- Monkey patch Snacks.picker.preview.file to provide a preview function
-- that renders markdown using the render-markdown plug-in.
local orig_preview_file = Snacks.picker.preview.file
Snacks.picker.preview.file = function(ctx)
  local retval = orig_preview_file(ctx)
  if ctx.item.file and ctx.item.file:find("%.md$") then
    -- render-markdown does nothing unless the buffer's ft is
    -- markdown, so temporarily change the ft to markdown and
    -- restore when we are done as this buf is reused by snacks.
    local render = require("render-markdown.core.ui")
    local saved_ft = vim.bo[ctx.buf].filetype
    vim.bo[ctx.buf].buftype = "nofile"
    vim.bo[ctx.buf].filetype = "markdown"
    render.update(ctx.buf, ctx.win, "Snacks", true)
    vim.schedule(function()
      vim.bo[ctx.buf].filetype = saved_ft
      vim.bo[ctx.buf].buftype = ""
    end)
  end
  return retval
end

return M
