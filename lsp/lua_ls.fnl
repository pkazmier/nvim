;; This will be merged with the rest neovim-lspconfig configuration.

(fn on-attach [client buf-id]
  ;; Reduce unnecessarily long list of completion triggers for better
  ;; 'mini.completion' experience
  (set client.server_capabilities.completionProvider.triggerCharacters
       ["." ":" "#" "("]))

{:on_attach on-attach
 :settings {:Lua {:workspace {:checkThirdParty false}
                  :codeLens {:enable true}
                  :completion {:callSnippet :Replace}
                  :doc {:privateName ["^_"]}
                  :hint {:enable true
                         :setType false
                         :paramType true
                         :paramName :Disable
                         :semicolon :Disable
                         :arrayIndex :Disable}}
            :telemetry {:enable false}}}
