-- ---------------------------------------------------------------------------
-- treesitter
-- ---------------------------------------------------------------------------

Config.now_if_args(function()
  local ts_update = function() vim.cmd("TSUpdate") end
  Config.on_packchanged("tree-sitter", { "update" }, ts_update, "Update tree-sitter parsers")

  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", load = true },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  })

  local ensure_languages = {
    "bash",
    "css",
    "fennel",
    "go",
    "helm",
    "html",
    "java",
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
    "vhs",
    "yaml",
    "zig",
  }

  require("nvim-treesitter").install(ensure_languages)

  -- Let the markdown parser handle pandoc buffers too.
  vim.treesitter.language.register("markdown", { "pandoc" })

  -- Start treesitter for any buffer whose filetype has an installed parser.
  -- Deliberately NOT a precomputed filetype list: that raced with
  -- nvim-treesitter's (main) filetype registration and silently dropped
  -- just-installed parsers such as fennel from the pattern, so they never got
  -- highlighted. `pcall` no-ops on filetypes that have no parser.
  Config.new_autocmd("FileType", {
    callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
  })

  -- Display context when current block is off-screen
  require("treesitter-context").setup()
end)
