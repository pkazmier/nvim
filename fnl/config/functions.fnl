;; fnl/config/functions.fnl

;; Pretty printer. Deliberately a GLOBAL -- it exists for interactive
;; debugging (:lua pp(...)), where requiring a module first defeats the point.
(let [fennel (require :hotpot.fennel)]
  (fn _G.pp [...]
    (vim.notify (fennel.view [...]))))

;; Random choice
(math.randomseed (os.time))
(fn choose [choices]
  (. choices (math.random 1 (length choices))))

;; Return info for hl_name or nil if it does not exist
(fn get-hl [hl-name]
  (let [hl-info (vim.api.nvim_get_hl 0 {:name hl-name :link false})]
    (when (not (vim.tbl_isempty hl-info)) hl-info)))

;; Open a new scratch buffer in the current window. This differs from `:enew`
;; in that it creates a new empty buffer rather than reusing the existing
;; empty buffer if one exists. It also sets the buffer to be a scratch buffer
;; (i.e. not listed, not saved to disk).
(fn new-scratch-buffer []
  (vim.api.nvim_win_set_buf 0 (vim.api.nvim_create_buf true true)))

;; Re-map binding
(fn remap [mode lhs-from lhs-to]
  (let [keymap (vim.fn.maparg lhs-from mode false true)
        rhs (or keymap.callback keymap.rhs)]
    (assert rhs (.. "Could not remap from " lhs-from " to " lhs-to))
    (vim.keymap.set mode lhs-to rhs {:desc keymap.desc})))

(fn capitalize [w]
  (.. (string.upper (w:sub 1 1)) (w:sub 2)))

;; ---------------------------------------------------------------------------
;; Hydra Brackets
;; ---------------------------------------------------------------------------
;;
;; Generate keymaps for bracketed navigation tuned for repeated motions. For
;; example, mini.bracketed defines the following mappings to navigate between
;; diagnostics:
;;
;;   [D : go to first diagnostic
;;   ]D : go to last diagnostic
;;   [d : go to previous diagnostic
;;   ]d : go to next diagnostic
;;
;; With this setup, if one wanted to move forward three diagnostics and then
;; back one, it would require the following keypresses: ]d]d]d[d. This is
;; a bit cumbersome for me as a Dvorak user due to placement of [ and ] in
;; the number row.
;;
;; We could take advantage af postkey in mini.clue to eliminate the need for
;; repeated keypresses of the the brackets. In that case, the above example
;; would be ]ddd<C-c>[d<C-c>. However, this still requires the user to switch
;; back and forth between the left and right brackets when changing direction.
;;
;; To make this more efficient, we can remap the uppercase versions of the
;; suffixes to navigate in the opposite direction. This way, the user can stay
;; on one side of the keyboard when changing direction. The above example
;; would then be ]ddD<C-c>. This is much more efficient for my typing style.
;;
;; This function returns the clues for mini.clue and sets the mappings to
;; achieve this. I use it twice in my config to change the mini.bracketed
;; mappings as well as goto-hunk mappings from mini.diff.
;;
;; Let's look at an example to see how this function achieves the above. By
;; default, after mini.bracketed.setup() has been called, mappings have been
;; established in the form of for many suffixes (I'm only showing 'd' here):
;;
;;     vim.keymap.set("n", "[D", "<Cmd>lua MiniBracketed.diagnostic('first')<Cr>",    { desc = "Diagnostic first" })
;;     vim.keymap.set("n", "[d", "<Cmd>lua MiniBracketed.diagnostic('backward')<Cr>", { desc = "Diagnostic backward" })
;;     vim.keymap.set("n", "]D", "<Cmd>lua MiniBracketed.diagnostic('last')<Cr>",     { desc = "Diagnostic last" })
;;     vim.keymap.set("n", "]d", "<Cmd>lua MiniBracketed.diagnostic('forward')<Cr>",  { desc = "Diagnostic forward" })
;;
;; If we want to change those diagnostic mappings, then we can call this
;; function with the following arguments (suffixes should be lowercase):
;;
;;     (local clues (functions.gen_hydra_brackets [:d]
;;                                                {"[" {:old :first :new :forward}
;;                                                 "]" {:old :last :new :backward}}))
;;
;; It returns the following clues, which use postkeys in the mini.clue spec.
;;
;;       { { keys = "[d", mode = "n", postkeys = "[", },
;;         { keys = "[D", mode = "n", postkeys = "[", },
;;         { keys = "]d", mode = "n", postkeys = "]", },
;;         { keys = "]D", mode = "n", postkeys = "]", } }
;;
;; It then updates the mappings that were created by mini.bracketed to the
;; following (changes in uppercase):
;;
;;     vim.keymap.set("n", "[D", "<Cmd>lua MiniBracketed.diagnostic('FORWARD')<Cr>",  { desc = "Diagnostic FORWARD" })
;;     vim.keymap.set("n", "]D", "<Cmd>lua MiniBracketed.diagnostic('BACKWARD')<Cr>", { desc = "Diagnostic BACKWARD" })
;;
;; This function can only work with a string-based RHS such as those defined
;; by mini.bracketed and mini.diff. The list of suffixes passed should be the
;; lowercase variants of the movement key ('d' instead of 'D' for example).
(fn gen-hydra-brackets [suffixes replacements]
  (local clues {})
  (each [_ suffix (ipairs suffixes)]
    (let [lower-suffix suffix
          upper-suffix (suffix:upper)]
      (each [bracket pattern (pairs replacements)]
        (table.insert clues {:mode :n
                             :keys (.. bracket lower-suffix)
                             :postkeys bracket})
        (table.insert clues {:mode :n
                             :keys (.. bracket upper-suffix)
                             :postkeys bracket})
        (let [map (vim.fn.maparg (.. bracket upper-suffix) :n false true)
              new-rhs (map.rhs:gsub pattern.old pattern.new)
              new-desc (-> map.desc
                           (string.gsub pattern.old pattern.new)
                           (string.gsub (capitalize pattern.old)
                                        (capitalize pattern.new)))]
          (vim.keymap.set :n (.. bracket upper-suffix) new-rhs {:desc new-desc})))))
  clues)

{:pp _G.pp
 : choose
 :get_hl get-hl
 :new_scratch_buffer new-scratch-buffer
 : remap
 :gen_hydra_brackets gen-hydra-brackets}
