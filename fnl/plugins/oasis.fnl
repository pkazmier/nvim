;; ---------------------------------------------------------------------------
;; oasis colorscheme
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; fnlfmt: skip
(with-later! ; oasis
  (vim.pack.add [{:src "https://github.com/uhs-robert/oasis.nvim"}])
  (local oasis (require :oasis))
  (oasis.setup {:highlight_overrides (fn [c colors]
                                       {;; because I use laststatus=2
                                        :WinSeparator                   {:fg c.bg.surface :bg c.theme.bg}
                                        :MiniStatuslineDirectory        {:fg c.theme.light_primary :bg c.bg.mantle}
                                        :MiniStatuslineFilename         {:fg c.theme.light_primary :bg c.bg.mantle :bold true}
                                        :MiniStatuslineFilenameModified {:fg c.theme.light_primary :bg c.bg.mantle :bold true}})})
  ;; (vim.cmd.colorscheme :oasis)
  )
