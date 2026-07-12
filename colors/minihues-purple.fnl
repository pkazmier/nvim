(local hues (require :mini.hues))

(hues.setup {:background "#232030" :foreground "#c6c6cd" :accent :purple})
(local p (hues.get_palette))
(set p.accent_bg p.bg_edge)
(hues.apply_palette p)
(set vim.g.colors_name :minihues-purple)
