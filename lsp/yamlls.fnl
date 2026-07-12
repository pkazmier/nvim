;; Kill the yamlls if editing a helm chart because we want helmls instead.
(fn kill-yamlls-on-helm [args]
  (local client (assert (vim.lsp.get_client_by_id args.data.client_id)))
  (when (and (= client.name :yamlls)
             (= (. (. vim.bo args.buf) :filetype) :helm))
    (vim.schedule (fn []
                    (vim.cmd (.. "LspStop ++force " args.data.client_id))))))

(local autocmds (require :config.autocmds))
(autocmds.new :LspAttach {:callback kill-yamlls-on-helm})

{}
