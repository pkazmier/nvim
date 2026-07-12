;; ---------------------------------------------------------------------------
;; quicker
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; quicker
  (vim.pack.add [{:src "https://github.com/stevearc/quicker.nvim"}])
  (local quicker (require :quicker))
  (quicker.setup {:keys [{1 ">"
                          2 "<Cmd>lua require('quicker').expand({ add_to_existing = true })<Cr>"
                          :desc "Expand quickfix context"}
                         {1 "<"
                          2 "<Cmd>lua require('quicker').collapse()<Cr>"
                          :desc "Collapse quickfix context"}]}))
