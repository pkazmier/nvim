;; ---------------------------------------------------------------------------
;; vim-helm
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(with-now-if-args! ; vim-helm
  (vim.pack.add [{:src "https://github.com/towolf/vim-helm"}]))
