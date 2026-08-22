-- ---------------------------------------------------------------------------
-- mini.completion
-- ---------------------------------------------------------------------------

local loader = require("config.loader")
local autocmds = require("config.autocmds")

loader.now_if_args(function()
  local completion = require("mini.completion")
  completion.setup({
    lsp_completion = { source_func = "omnifunc", auto_setup = false },
    mappings = { force_fallback = "" },
  })

  local on_attach = function(args) vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end
  autocmds.new("LspAttach", { callback = on_attach })

  -- Advertise to servers that Neovim now supports certain set of completion and
  -- signature features through 'mini.completion'.
  vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })
end)
