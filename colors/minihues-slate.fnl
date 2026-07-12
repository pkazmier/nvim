(local hues (require :mini.hues))

(hues.setup {:background "#1a2331" :foreground "#c3c7cd" :accent :azure})
(local p (hues.get_palette))
(set p.accent_bg p.bg_edge)
(hues.apply_palette p)
(set vim.g.colors_name :minihues-slate)
