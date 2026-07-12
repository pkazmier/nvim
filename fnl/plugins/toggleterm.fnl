;; ---------------------------------------------------------------------------
;; toggleterm
;; ---------------------------------------------------------------------------
(import-macros {: with-later!} :macros)

;; Bound to <leader>gg in keymaps
(fn lazygit []
  (let [terminal (require :toggleterm.terminal)
        term (terminal.Terminal:new {:cmd :lazygit
                                     :hidden true
                                     :highlights {:FloatBorder {:link :FloatBorder}}
                                     :direction :float
                                     :on_open (fn [term]
                                                (vim.keymap.del :t :<Esc><Esc>
                                                                {:buffer term.bufnr}))})]
    (term:toggle)))

(with-later! ; toggleterm
  (vim.pack.add [{:src "https://github.com/akinsho/toggleterm.nvim"}])
  (local toggleterm (require :toggleterm))
  (toggleterm.setup {:direction :float
                     :highlights {:NormalFloat {:link :NormalFloat}
                                  :FloatBorder {:link :FloatBorder}}
                     :float_opts {:border :rounded :winblend 0}
                     :open_mapping "<c-\\>"
                     :on_create (fn [term]
                                  (vim.keymap.set :t :<Esc><Esc> "<C-\\><C-n>"
                                                  {:buffer term.bufnr}))}))

{: lazygit}
