;; ---------------------------------------------------------------------------
;; nvim-lint
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

(with-later! ; nvim-lint
  (vim.pack.add [{:src "https://github.com/mfussenegger/nvim-lint"}])
  (local lint (require :lint))
  (set lint.linters_by_ft {:markdown [:markdownlint-cli2]
                           :sql [:sqruff]
                           :sh [:shellcheck]
                           :bash [:shellcheck]})
  (local autocmds (require :config.autocmds))
  (autocmds.new [:BufEnter :BufWritePost :InsertLeave]
                {:callback (fn [] (lint.try_lint))}))
