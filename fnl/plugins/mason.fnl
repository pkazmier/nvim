;; ---------------------------------------------------------------------------
;; mason
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(with-now-if-args! ; mason
  (vim.pack.add [{:src "https://github.com/williamboman/mason.nvim"}])
  (local mason (require :mason))
  (mason.setup))
