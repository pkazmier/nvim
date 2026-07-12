(local hues (require :mini.hues))

(hues.setup {:background "#151025" :foreground "#B6BCBF" :accent :purple})
(local p (hues.get_palette))
(set p.accent_bg p.bg_edge)
(hues.apply_palette p)
(set vim.g.colors_name :minihues-darkpurple)
