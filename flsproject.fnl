;; fennel-ls project configuration.
;;
;; fennel-ls reads its config ONLY from this file at the project root -- it
;; ignores LSP `settings` / `initializationOptions` entirely (v0.2.1). Keys are
;; flat: :extra-globals :lua-version :libraries :lints :fennel-path :macro-path.
;;
;; :extra-globals is a SPACE-SEPARATED STRING of allowed globals -- listing
;; `vim` silences the "unknown identifier: vim" diagnostics in our Neovim config.
;;
;; :fennel-path / :macro-path -- our modules live under fnl/ (config.options ->
;; fnl/config/options.fnl, :macros -> fnl/macros.fnlm). fennel-ls's defaults are
;; root-relative (./?.fnl, ./?.fnlm) and don't include fnl/, so we prepend it
;; here -- mirroring what hotpot does to fennel.path/macro-path at runtime.
{:extra-globals "vim"
 :fennel-path "./fnl/?.fnl;./fnl/?/init.fnl;./?.fnl;./?/init.fnl"
 :macro-path "./fnl/?.fnlm;./fnl/?/init.fnlm;./fnl/?.fnl;./fnl/?/init-macros.fnl;./fnl/?/init.fnl;./?.fnlm;./?/init.fnlm;./?.fnl"}
