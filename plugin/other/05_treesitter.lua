-- ---------------------------------------------------------------------------
-- treesitter
-- ---------------------------------------------------------------------------

Config.now_if_args(function()
  local ts_update = function() vim.cmd("TSUpdate") end
  Config.on_packchanged("tree-sitter", { "update" }, ts_udpate, "Update tree-sitter parsers")

  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", load = true },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  })

  local ensure_languages = {
    "bash",
    "css",
    "go",
    "helm",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "sql",
    "toml",
    "yaml",
    "zig",
  }

  require("nvim-treesitter").install(ensure_languages)
  local filetypes = vim.iter(ensure_languages):map(vim.treesitter.language.get_filetypes):flatten():totable()
  vim.list_extend(filetypes, { "markdown", "pandoc" })
  Config.new_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })

  -- Display context when current block is off-screen
  require("treesitter-context").setup()
end)
