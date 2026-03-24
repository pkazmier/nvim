-- ---------------------------------------------------------------------------
-- lume
-- ---------------------------------------------------------------------------

Config.later(function()
  vim.pack.add({ { src = "https://github.com/danfry1/lume" } })
  require("lume").setup({
    custom_highlights = function(colors, variant)
      return {
        -- Lume doesn't add color to properties, which is bland IMO.
        ["@property"] = { fg = colors.accents.teal },
        ["@lsp.type.variable"] = { link = "@lsp" },
      }
    end,
  })
end)
