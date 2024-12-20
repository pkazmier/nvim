require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },
  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
    },
  },
  signature = {
    enabled = true,
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "normal",
  },
})
