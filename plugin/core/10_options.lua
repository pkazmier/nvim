-- stylua: ignore start

-- ---------------------------------------------------------------------------
-- Custom globals
-- ---------------------------------------------------------------------------

Config.copilot_disable = vim.fn.expand("$USER") == "kaz"

-- ---------------------------------------------------------------------------
-- Global settings
-- ---------------------------------------------------------------------------

vim.g.mapleader        = " "
vim.g.maplocalleader   = " "

-- ---------------------------------------------------------------------------
-- General settings
-- ---------------------------------------------------------------------------

vim.opt.breakindentopt = "list:-1"
vim.opt.complete       = '.,w,b,kspell'
vim.opt.completeopt    = "menuone,noselect,fuzzy"
vim.opt.conceallevel   = 2
vim.opt.confirm        = true
vim.opt.expandtab      = true
vim.opt.fillchars      = { fold="╌", diff="╱", eob=" " }
vim.opt.formatlistpat  = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.opt.formatoptions  = "jcrql1nt"
vim.opt.grepformat     = "%f:%l:%c:%m"
vim.opt.grepprg        = "rg --vimgrep"
vim.opt.list           = true
vim.opt.listchars      = { extends="…", precedes="…", tab="  ", nbsp="␣" }
vim.opt.pumborder      = "rounded"
vim.opt.pumheight      = 10
vim.opt.shiftround     = true
vim.opt.shiftwidth     = 2
vim.opt.shortmess      = "FOSWICaco"
vim.opt.spelloptions   = "camel"
vim.opt.splitkeep      = "cursor"
vim.opt.textwidth      = 78
vim.opt.winborder      = "rounded"
vim.opt.winminwidth    = 5

-- ---------------------------------------------------------------------------
-- Fold settings
-- ---------------------------------------------------------------------------

vim.opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel      = 99
vim.opt.foldmethod     = "expr"
vim.opt.foldnestmax    = 10
vim.opt.foldtext       = ""

-- ---------------------------------------------------------------------------
-- Diagnostics
-- ---------------------------------------------------------------------------

local diagnostic_opts = {
  severity_sort = true,
  underline = false,
  update_in_insert = false,
  virtual_text = {
    current_line = true,
  },
}
MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)

-- stylua: ignore end
