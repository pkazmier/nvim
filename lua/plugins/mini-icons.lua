-- ---------------------------------------------------------------------------
-- mini.icons
-- ---------------------------------------------------------------------------

local loader = require("config.loader")

loader.now(function()
  local icons = require("mini.icons")
  icons.setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
    end,
  })
  loader.later(icons.mock_nvim_web_devicons)
  loader.later(icons.tweak_lsp_kind)
end)
