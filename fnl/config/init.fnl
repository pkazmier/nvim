;; ===========================================================================
;; config/init.fnl -- load manifest
;; ===========================================================================

(require :config.options)
(require :config.functions)
(require :config.autocmds)
(require :config.keymaps)

;; --- plugins
(each [_ m (ipairs [;; now / early UI
                    :plugins.mini-basics
                    :plugins.mini-hues
                    :plugins.mini-icons
                    :plugins.mini-notify
                    :plugins.mini-sessions
                    :plugins.mini-starter
                    :plugins.mini-statusline
                    :plugins.mini-tabline
                    :plugins.thorn
                    :plugins.ui2
                    :plugins.orgmode
                    ;; now-if-args (now if a file opened, else later)
                    :plugins.mini-map
                    :plugins.mini-misc
                    :plugins.render-markdown
                    :plugins.treesitter
                    :plugins.vim-helm
                    :plugins.mini-completion
                    :plugins.mason
                    :plugins.oil
                    ;; later (any order)
                    :plugins.mini-input
                    :plugins.mini-ai
                    :plugins.mini-align
                    :plugins.mini-animate
                    :plugins.mini-bracketed
                    :plugins.mini-bufremove
                    :plugins.mini-cmdline
                    :plugins.mini-colors
                    :plugins.mini-comment
                    :plugins.mini-cursorword
                    :plugins.mini-diff
                    :plugins.mini-extra
                    :plugins.mini-files
                    :plugins.mini-git
                    :plugins.mini-hipatterns
                    :plugins.mini-keymap
                    :plugins.mini-indentscope
                    :plugins.mini-jump
                    ;; :plugins.mini-jump2d (disabled -- prefer leap, see file)
                    :plugins.mini-move
                    :plugins.mini-operators
                    :plugins.mini-snippets
                    :plugins.mini-pairs
                    :plugins.mini-pick
                    :plugins.mini-splitjoin
                    :plugins.mini-statuscolumn
                    :plugins.mini-surround
                    :plugins.mini-trailspace
                    :plugins.mini-visits
                    ;; mini-clue must load AFTER mini-bracketed and mini-diff
                    ;; (it consumes the clues they export)
                    :plugins.mini-clue
                    ;; other plugins
                    :plugins.codecompanion
                    :plugins.conform
                    :plugins.copilot
                    :plugins.friendly-snippets
                    :plugins.lazydev
                    :plugins.leap
                    :plugins.lsp
                    :plugins.nvim-lint
                    ;; :plugins.nvim-autopairs (disabled -- evaluating mini.pairs, see file)
                    :plugins.quicker
                    :plugins.toggleterm
                    :plugins.undotree
                    ;; colorschemes
                    :plugins.ayu
                    :plugins.boo-berry
                    :plugins.catppuccin
                    :plugins.everforest
                    :plugins.gruvbox-material
                    :plugins.kanagawa
                    :plugins.lume
                    :plugins.mellow
                    :plugins.oasis
                    :plugins.rose-pine
                    :plugins.tokyonight])]
  (require m))
