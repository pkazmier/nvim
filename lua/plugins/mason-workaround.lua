-- mason and mason-lspconfig released version 2.0.
-- with some breaking changes, multiple methods have been changed
-- therefore (for now) a workaround is needed for Mason to still work in LazyVim
-- THIS WILL PIN the VERSION number, remove this file later, when it's no longer needed
return {
  { "mason-org/mason.nvim", version = "1.11.0" },
  { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
}
-- after adding/saving this file run :Lazy to potentially 're-install' the versions above
