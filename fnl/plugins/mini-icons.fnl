;; ---------------------------------------------------------------------------
;; mini.icons
;; ---------------------------------------------------------------------------
(import-macros {: with-now! : with-later!} :macros)

(with-now! ; mini.icons
  (local icons (require :mini.icons))
  (icons.setup {:use_file_extension (fn [ext _]
                                      (let [suf3 (ext:sub -3)
                                            suf4 (ext:sub -4)]
                                        (and (not= suf3 :scm) (not= suf3 :txt)
                                             (not= suf3 :yml) (not= suf4 :json)
                                             (not= suf4 :yaml))))})
  (with-later! (icons.mock_nvim_web_devicons))
  (with-later! (icons.tweak_lsp_kind)))
