-- ---------------------------------------------------------------------------
-- oasis colorscheme
-- ---------------------------------------------------------------------------

Config.now(function()
  vim.pack.add({ { src = "https://github.com/uhs-robert/oasis.nvim" } })
  require("oasis").setup({
    highlight_overrides = function(c, colors)
      -- stylua: ignore
      return {
        MiniStatuslineDirectory        = { fg = c.theme.light_primary, bg = c.bg.mantle },
        MiniStatuslineFilename         = { fg = c.theme.light_primary, bg = c.bg.mantle, bold = true },
        MiniStatuslineFilenameModified = { fg = c.theme.light_primary, bg = c.bg.mantle, bold = true },
      }
    end,
  })
  vim.cmd.colorscheme("oasis")
end)
