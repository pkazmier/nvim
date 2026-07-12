;; ---------------------------------------------------------------------------
;; mini.statusline
;; ---------------------------------------------------------------------------
;;
;; While the default statusline is sufficient, there are several enhancements
;; that I've made to improve usability and readability:
;;
;; 1. Don't show file encoding or file size as I've never needed this info.
;; 2. Don't show total lines or chars -- only show current line and column.
;; 3. Add visual separation between search results, lines, and column.
;; 4. Deemphasize the directory from the filename, and distinguish a modified
;;    filename. Uses MiniStatuslineDirectory / MiniStatuslineInactive /
;;    MiniStatuslineFilename / MiniStatuslineFilenameModified.
;; 5. Move diagnostics to the right, next to filetype and LSP, to group them
;;    and reduce noise on the Git-heavy left side.
(import-macros {: with-now!} :macros)

(local H {})
(local statusline (require :mini.statusline))

;; fnlfmt: skip
(with-now! ; mini.statusline
  (statusline.setup
    {:use_icons true
     :content {:inactive
               (fn []
                 (let [pathname (H.section_pathname {:trunc_width 120})]
                   (statusline.combine_groups
                     [{:hl :MiniStatuslineInactive :strings [pathname]}])))
               :active
               (fn []
                 (let [(mode mode-hl) (statusline.section_mode        {:trunc_width 120})
                       git            (statusline.section_git         {:trunc_width 40})
                       diff           (statusline.section_diff        {:trunc_width 80})
                       diagnostics    (statusline.section_diagnostics {:trunc_width 60})
                       lsp            (statusline.section_lsp         {:trunc_width 40})
                       filetype       (H.section_filetype             {:trunc_width 70})
                       location       (H.section_location             {:trunc_width 120})
                       recording      (H.section_recording            {:trunc_width 120})
                       search         (H.section_searchcount          {:trunc_width 80})
                       pathname       (H.section_pathname
                                        {:trunc_width 100
                                         :filename_hl :MiniStatuslineFilename
                                         :modified_hl :MiniStatuslineFilenameModified})]
                   (statusline.combine_groups
                     [{:hl mode-hl                  :strings [(mode:upper)]}
                      {:hl :MiniStatuslineDevinfo   :strings [git diff]}
                      "%<"
                      {:hl :MiniStatuslineDirectory :strings [pathname]}
                      "%="
                      {:hl :DiagnosticWarn          :strings [recording]}
                      {:hl :MiniStatuslineFileinfo  :strings [diagnostics filetype lsp]}
                      {:hl mode-hl                  :strings [(.. search location)]}
                      {:hl :MiniStatuslineDirectory :strings []}])))}}))

(fn H.isnt_normal_buffer [] (not= vim.bo.buftype ""))

;; fnlfmt: skip
(fn H.get_filetype_icon []
  ;; require here so we don't depend on plugin initialization order
  (let [(has-devicons devicons) (pcall require :nvim-web-devicons)]
    (if (not has-devicons) ""
        (devicons.get_icon (vim.fn.expand "%:t")
                           (vim.fn.expand "%:e")
                           {:default true}))))

;; fnlfmt: skip
(fn H.section_location [args]
  ;; Use virtual column number to allow update when past last column
  (if (statusline.is_truncated args.trunc_width) "%-2l│%-2v"
      "󰉸 %-2l│󱥖 %-2v"))

;; fnlfmt: skip
(fn H.section_filetype [args]
  (let [ft vim.bo.filetype]
    (if (or (statusline.is_truncated args.trunc_width)
            (= ft "")
            (H.isnt_normal_buffer)) ""
        (let [icon (H.get_filetype_icon)]
          (if (= icon "") ft (string.format "%s %s" icon ft))))))

;; fnlfmt: skip
(fn H.section_recording [args]
  (let [is-recording (vim.fn.reg_recording)]
    (if (= is-recording "") ""
        (let [msg (if (statusline.is_truncated args.trunc_width) "" "recording ")]
          (string.format "%s%s" msg is-recording)))))

;; fnlfmt: skip
(fn H.section_searchcount [args]
  ;; `searchcount()` can error when evaluated often (e.g. `/` then `\(` gives
  ;; E54), so guard it with pcall.
  (if (= vim.v.hlsearch 0) ""
      (let [opts (or (. (or args {}) :options) {:recompute true})
            (ok s-count) (pcall vim.fn.searchcount opts)
            icon (if (statusline.is_truncated args.trunc_width) "" " ")]
        (if (or (not ok) (= s-count.current nil) (= s-count.total 0))
            ""
            (= s-count.incomplete 1)
            (.. icon "?⧸?│")
            (let [too-many (string.format ">%d" s-count.maxcount)
                  current (if (> s-count.current s-count.maxcount) too-many s-count.current)
                  total (if (> s-count.total s-count.maxcount) too-many s-count.total)]
              (string.format "%s%s⧸%s│" icon current total))))))

(fn H.section_pathname [args]
  (let [args (or args {})]
    (if (= vim.bo.buftype :terminal)
        "%t"
        (let [sep (package.config:sub 1 1)
              cwd (or (vim.uv.fs_realpath (or (vim.uv.cwd) "")) "")
              path (vim.fn.expand "%:p")
              path (if (= 1 (path:find cwd 1 true))
                       (path:sub (+ (length cwd) 2))
                       path)
              parts (vim.split path sep)
              n (length parts)
              parts (if (and (statusline.is_truncated (or args.trunc_width 80))
                             (> n 3))
                        [(. parts 1) "…" (. parts (- n 1)) (. parts n)]
                        parts)
              n (length parts)
              dir (if (> n 1)
                      (.. (table.concat parts sep 1 (- n 1)) sep)
                      "")
              hl (if vim.bo.modified args.modified_hl args.filename_hl)
              file-hl (if hl (.. "%#" hl "#") "")
              modified (if vim.bo.modified " [+]" "")]
          (.. dir file-hl (. parts n) modified)))))
