;; ---------------------------------------------------------------------------
;; mini.git
;; ---------------------------------------------------------------------------
(import-macros {: with-later! : set-local!} :macros)

(local git-log-cmd
       "Git log --pretty=format:\\%h\\ \\%as\\ │\\ \\%s\\%d\\ [\\%an] --graph --all")

(fn log [] (vim.cmd git-log-cmd))

(fn log-buf [] (vim.cmd (.. git-log-cmd " --follow -- %")))

(with-later! ; mini.git
  (local git (require :mini.git))
  (git.setup {})
  (local autocmds (require :config.autocmds))
  (autocmds.new :FileType
                {:pattern [:git :diff]
                 :desc "Set fold configuration for mini.git"
                 :callback (fn []
                             (set-local! foldmethod :expr)
                             (set-local! foldexpr
                                         "v:lua.MiniGit.diff_foldexpr()"))}))

{: log :log_buf log-buf}
