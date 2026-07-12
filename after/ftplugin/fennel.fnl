;; ---------------------------------------------------------------------------
;; Fennel buffer-local settings
;; ---------------------------------------------------------------------------

;; Comment with the conventional double semicolon
(set vim.bo.commentstring ";; %s")

;; Customize 'mini.splitjoin' for lisp syntax: arguments are separated by
;; whitespace instead of commas, and brackets stay glued to the first/last
;; arguments instead of moving onto their own lines:
;;
;;   {:a 1 :b 2}         <->  {:a 1        [:one :two :three]  <->  [:one
;;                             :b 2}                                 :two
;;                                                                   :three]
;;
;; `{}` tables and `let` binding vectors split one PAIR per line; other `[]`
;; sequences split one element per line. `()` forms are left alone.

;; Opening bracket of the split in progress, stashed by the pre-hook so the
;; post-hook can align continuation lines under it.
(var bracket nil)

(fn pairwise? [line col]
  ;; `{}` tables hold key/value pairs; so does a `[` directly preceded by
  ;; `let` on the same line (its binding vector). The `%f[%w]` frontier
  ;; rejects identifiers merely ending in "let".
  (let [char (line:sub col col)]
    (or (= char "{")
        (and (= char "[")
             (not= nil (string.match (line:sub 1 (- col 1)) "%f[%w]let%s*$"))))))

(fn split_positions [positions]
  ;; Input positions: opening bracket, inner separators..., closing bracket.
  ;; Drop both brackets so they stay glued to their arguments, and for
  ;; pair-wise regions keep every SECOND separator so pairs stay together.
  (let [n (length positions)
        first (. positions 1)
        line (vim.fn.getline first.line)
        step (if (pairwise? line first.col) 2 1)
        kept []]
    (set bracket first)
    (for [i (+ 1 step) (- n 1) step]
      (table.insert kept (. positions i)))
    kept))

(fn split_reindent [positions]
  ;; `split_at` indents continuation lines by shiftwidth; re-indent them to
  ;; align under the first argument instead. The last input position sits on
  ;; the region's final line (appended by 'mini.splitjoin' for hook use).
  (when bracket
    (let [line (vim.fn.getline bracket.line)
          indent (string.rep " "
                             (vim.fn.strdisplaywidth (line:sub 1 bracket.col)))
          last (. positions (length positions))]
      (for [lnum (+ bracket.line 1) last.line]
        (let [cur (vim.fn.getline lnum)
              old (cur:match "^%s*")]
          (vim.api.nvim_buf_set_text 0 (- lnum 1) 0 (- lnum 1) (length old)
                                     [indent]))))
    (set bracket nil))
  positions)

(fn join_seam_cols [positions]
  ;; Seam positions sit on each line's LAST character. If that is trailing
  ;; whitespace, `join_at` deletes it and the extmark tracking the seam
  ;; drifts onto the next line's first character, making `join_pad` below
  ;; pad the wrong side of it. Move seams onto the last non-blank character.
  (each [_ pos (ipairs positions)]
    (let [rstripped (: (vim.fn.getline pos.line) :gsub "%s+$" "")]
      (set pos.col (math.max (length rstripped) 1))))
  positions)

(fn join_pad [positions]
  ;; `join_at` pads inner seams with a space but the first and last seams
  ;; with nothing (it assumes brackets sat on their own lines); with glued
  ;; brackets those seams separate arguments, so pad them too. The last
  ;; input position is not a seam (appended by 'mini.splitjoin') -- skip it.

  (fn pad [pos]
    (vim.api.nvim_buf_set_text 0 (- pos.line 1) pos.col (- pos.line 1) pos.col
                               [" "]))

  (let [seams (- (length positions) 1)]
    (when (>= seams 1) (pad (. positions seams)))
    (when (>= seams 2) (pad (. positions 1))))
  positions)

(set vim.b.minisplitjoin_config
     {:detect {;; No `%b()`: splitting code forms one-arg-per-line is rarely
               ;; what you want in a lisp
               :brackets ["%b{}" "%b[]"]
               :separator "%s+"
               ;; Default minus `%b''`: single quote is Fennel's quote
               ;; shorthand, not a string delimiter
               :exclude_regions ["%b()" "%b[]" "%b{}" "%b\"\""]}
      :split {:hooks_pre [split_positions] :hooks_post [split_reindent]}
      :join {:hooks_pre [join_seam_cols] :hooks_post [join_pad]}})
