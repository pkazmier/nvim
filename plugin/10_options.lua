--stylua: ignore start

-- Custom globals
vim.g.kaz_copilot = vim.fn.expand("$USER") ~= "kaz"

-- Global editor settings ===================================================
vim.g.mapleader        = " "
vim.g.maplocalleader   = " "

-- General settings =========================================================
vim.o.breakindentopt   = "list:-1"
vim.o.completeopt      = "menuone,noselect,fuzzy"
vim.o.conceallevel     = 2
vim.o.confirm          = true
vim.o.expandtab        = true
vim.o.formatlistpat    = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions    = "jcroql1nt"
vim.o.grepformat       = "%f:%l:%c:%m"
vim.o.grepprg          = "rg --vimgrep"
vim.o.iskeyword        = '@,48-57,_,192-255,-' -- Treat dash separated words as a word text object
vim.o.list             = true
vim.o.pumheight        = 10
vim.o.shiftround       = true
vim.o.shiftwidth       = 2
vim.o.shortmess        = "FOSWICaco"
vim.o.spelloptions     = "camel"
vim.o.textwidth        = 78
vim.o.wildmode         = "longest:full,full"
vim.o.winborder        = "rounded"
vim.o.winminwidth      = 5

-- Fold settings ============================================================
vim.o.foldexpr         = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel        = 99
vim.o.foldmethod       = "expr"
vim.o.foldnestmax      = 10
vim.o.foldtext         = ""

vim.opt.fillchars           = { fold="╌", diff="╱", eob=" " }
vim.opt.listchars           = { extends="…", precedes="…", tab="  ", nbsp="␣" }

-- Custom autocommands ======================================================
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

--stylua: ignore end
