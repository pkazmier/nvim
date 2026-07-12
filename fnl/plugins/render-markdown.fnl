;; ---------------------------------------------------------------------------
;; render-markdown
;; ---------------------------------------------------------------------------
(import-macros {: with-now-if-args!} :macros)

(with-now-if-args! ; render-markdown
  (vim.pack.add [{:src "https://github.com/MeanderingProgrammer/render-markdown.nvim"}])
  (local render (require :render-markdown))
  (render.setup {:file_types [:markdown :md :codecompanion]
                 :render_modes [:n :no :c :t :i :ic]
                 :code {:sign false
                        :border :thin
                        :position :right
                        :width :block
                        :above "▁"
                        :below "▔"
                        :language_left "█"
                        :language_right "█"
                        :language_border "▁"
                        :left_pad 1
                        :right_pad 1}
                 :heading {:sign false
                           :width :block
                           :left_pad 1
                           :right_pad 0
                           :position :right
                           :icons (fn [ctx]
                                    (.. (string.rep "" ctx.level) ""))}})
  ;; Setup custom reverse video render-markdown heading hl groups based on
  ;; the fg color of existing markdown hl groups. This provides the fancy
  ;; headings when in preview mode.
  (local functions (require :config.functions))

  (fn setup-heading-hl-groups []
    (local fallback-hl-info
           (or (functions.get_hl "@markup.heading") (functions.get_hl :Title)))
    (for [lvl 1 6]
      (let [hl-name (.. "@markup.heading." lvl)
            hl-info (or (functions.get_hl (.. hl-name :.markdown))
                        (functions.get_hl hl-name) fallback-hl-info)]
        (assert hl-info
                "Must set one of 'Title', '@markup.heading', '@markup.heading.N', or '@markup.heading.N.markdown'")
        ;; nil-valued keys simply don't appear in the constructed table
        (local hl-spec {:fg hl-info.fg
                        :bg hl-info.bg
                        :bold hl-info.bold
                        :italic hl-info.italic})
        (vim.api.nvim_set_hl 0 (.. :RenderMarkdownH lvl) hl-spec)
        (set hl-spec.reverse true)
        (vim.api.nvim_set_hl 0 (.. :RenderMarkdownH lvl :Bg) hl-spec))))

  ;; Set the heading hl groups AND an autocmd for colorscheme changes.
  (setup-heading-hl-groups)
  (local autocmds (require :config.autocmds))
  (autocmds.new :Colorscheme
                {:desc "Setup up heading hl groups for render markdown."
                 :callback setup-heading-hl-groups}))
