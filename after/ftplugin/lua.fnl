(import-macros {: set-local!} :macros)

(vim.api.nvim_buf_set_keymap 0 :i :<M-i> " = " {:noremap true})

;; Use custom comment leaders to allow both nested variants (`--` and `----`)
;; and "docgen" variant (`---`).
(set-local! comments [":---" ":--"])

;; Customize 'mini.nvim'
(set vim.b.miniai_config {:custom_textobjects {:S ["%[%[().-()%]%]"]}})

(local mini-splitjoin (require :mini.splitjoin))
(local gen-hook mini-splitjoin.gen_hook)
(local curly {:brackets ["%b{}"]})

;; Add trailing comma when splitting inside curly brackets
(local add-comma-curly (gen-hook.add_trailing_separator curly))

;; Delete trailing comma when joining inside curly brackets
(local del-comma-curly (gen-hook.del_trailing_separator curly))

;; Pad curly brackets with single space after join
(local pad-curly (gen-hook.pad_brackets curly))

(set vim.b.minisplitjoin_config
     {:split {:hooks_post [add-comma-curly]}
      :join {:hooks_post [del-comma-curly pad-curly]}})

(set vim.b.minisurround_config
     {:custom_surroundings {:s {:input ["%[%[().-()%]%]"]
                                :output {:left "[[" :right "]]"}}}})

(local mini-snippets (require :mini.snippets))

;; `match` is a fennel special form, so the local needs another name
(fn match-fuzzy [snippets]
  (mini-snippets.default_match snippets {:pattern_fuzzy "[%w@_]*"}))

(set vim.b.minisnippets_config {:expand {:match match-fuzzy}})
