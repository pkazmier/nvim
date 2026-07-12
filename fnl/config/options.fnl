;; fnl/config/options.fnl
(import-macros {: set! : with-later!} :macros)

;; Disable AI assistance on the work machine (exported below; read by the
;; copilot and codecompanion plugin modules).
(local copilot-disable (= (vim.fn.expand :$USER) :kaz))

;; --- vim.g (not options) ---
(set vim.g.mapleader " ")

;; --- options: booleans use the shorthand, everything else (set! name value) ---
(set! breakindentopt "list:-1")
(set! cmdheight 0)
(set! complete ["." :w :b :kspell])
(set! completeopt [:menuone :noselect :fuzzy])
(set! completetimeout 100)
(set! conceallevel 2)
(set! confirm)
(set! expandtab)
(set! fillchars {:fold "╌"
                 :diff "╱"
                 :eob " "
                 :foldopen " "
                 :foldclose "🮥"
                 :foldsep " "
                 :foldinner " "})

(set! formatlistpat "^\\s*[0-9\\-\\+\\*]\\+[\\.\\)]*\\s\\+")
(set! formatoptions :jcrql1nt)
(set! grepformat "%f:%l:%c:%m")
(set! grepprg "rg --vimgrep")
(set! list)
(set! listchars {:extends "…" :precedes "…" :tab "  " :nbsp "␣"})
(set! pumborder :rounded)
(set! pumheight 10)
(set! shiftround)
(set! shiftwidth 2)
(set! shortmess :FOSWICaco)
(set! spelloptions :camel)
(set! splitkeep :cursor)
(set! textwidth 78)
(set! winborder :rounded)
(set! winminwidth 5)

;; --- fold settings ---
(set! numberwidth 5)
(set! signcolumn :number)
(set! foldcolumn :1)
(set! foldexpr "v:lua.vim.treesitter.foldexpr()")
(set! foldlevel 99)
(set! foldmethod :expr)
(set! foldnestmax 10)
(set! foldtext "")

;; --- diagnostics ---

;; fnlfmt: skip
(with-later!
  (vim.diagnostic.config {:severity_sort true
                          :underline false
                          :update_in_insert false
                          :virtual_text {:current_line true}}))

{:copilot_disable copilot-disable}
