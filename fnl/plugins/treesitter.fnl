;; ---------------------------------------------------------------------------
;; treesitter
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

;; fnlfmt: skip
(with-now-if-args! ; treesitter
  (local loader (require :config.loader))
  (loader.on_packchanged :tree-sitter [:update]
                         (fn [] (vim.cmd :TSUpdate))
                         "Update tree-sitter parsers")

  (vim.pack.add [{:src "https://github.com/nvim-treesitter/nvim-treesitter" :version :main :load true}
                 {:src "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" :version :main}
                 {:src "https://github.com/nvim-treesitter/nvim-treesitter-context"}])

  (local ensure-languages [:bash
                           :css
                           :fennel
                           :go
                           :helm
                           :html
                           :java
                           :javascript
                           :json
                           :lua
                           :markdown
                           :markdown_inline
                           :python
                           :regex
                           :rust
                           :sql
                           :toml
                           :vhs
                           :yaml
                           :zig])

  (local treesitter (require :nvim-treesitter))
  (treesitter.install ensure-languages)

  ;; Let the markdown parser handle pandoc buffers too.
  (vim.treesitter.language.register :markdown [:pandoc])

  ;; Start treesitter for any buffer whose filetype has an installed parser.
  ;; Deliberately NOT a precomputed filetype list: that raced with
  ;; nvim-treesitter's (main) filetype registration and silently dropped
  ;; just-installed parsers such as fennel from the pattern, so they never got
  ;; highlighted. `pcall` no-ops on filetypes that have no parser.
  (local autocmds (require :config.autocmds))
  (autocmds.new :FileType
                {:callback (fn [ev] (pcall vim.treesitter.start ev.buf))})

  ;; Display context when current block is off-screen
  (local context (require :treesitter-context))
  (context.setup))
