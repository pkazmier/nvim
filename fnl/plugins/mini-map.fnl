;; ---------------------------------------------------------------------------
;; mini.map
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(local map (require :mini.map))

(with-now-if-args! ; mini.map
  (map.setup {:integrations [(map.gen_integration.builtin_search)
                             (map.gen_integration.diff)
                             (map.gen_integration.diagnostic)]
              :symbols {:encode (map.gen_encode_symbols.dot :4x2)}
              ;; place above treesitter-context, which is 20
              :window {:zindex 21}})
  ;; Refresh minimap on certain movements
  (each [_ key (ipairs [:n :N "*" "#"])]
    (vim.keymap.set :n key
                    (.. key
                        "zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>"))))

;; Filetypes where the minimap is enabled automatically.
(local auto-enable {:go true
                    :lua true
                    :fennel true
                    :markdown true
                    :python true
                    :rust true})

;; Return true if the current buffer is supposed to have a map.
;; 1. User has explicitly enabled it via buf-toggle
;; 2. Filetype of buffer is in the auto-enable table
(fn should-be-enabled? []
  (let [disabled vim.b.minimap_disable
        enabled-explicitly (= vim.b.minimap_disable false)]
    (or enabled-explicitly (and (. auto-enable vim.bo.filetype) (not disabled)))))

;; Toggle the global visibility of the map. If it is currently shown, then
;; hide it. If it is not, then show it if the current buffer is supposed to
;; have a map.
(fn toggle []
  (set vim.g.minimap_disable (not vim.g.minimap_disable))
  (when (should-be-enabled?) (map.toggle)))

;; Toggle whether the current buffer should display a map if it has not been
;; globally disabled via toggle.
(fn buf-toggle []
  (if (should-be-enabled?)
      (do
        (set vim.b.minimap_disable true)
        (map.close))
      (do
        (set vim.b.minimap_disable false)
        (map.open))))

(local autocmds (require :config.autocmds))

;; fnlfmt: skip
(autocmds.new
  :BufEnter
  {:desc "Toggle 'mini.map' based on filetype"
   :callback (vim.schedule_wrap (fn []
                                  ;; Do nothing if entering the minimap buffer
                                  ;; itself (when focusing)
                                  (when (not= vim.bo.filetype :minimap)
                                    ;; Otherwise check if the minimap should
                                    ;; be opened or not
                                    (if (should-be-enabled?)
                                        (map.open)
                                        (map.close)))))})

{: toggle :buf_toggle buf-toggle}
