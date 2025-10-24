local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
now_if_args(function()
  -- Add post hook to run after every update, but not first-time install
  Config.new_autocmd({ "PackChanged" }, {
    callback = function(ev)
      local name, active, kind = ev.data.spec.name, ev.data.active, ev.data.kind
      if name == "tree-sitter" and kind == "update" and active then
        vim.cmd("TSUpdate")
      end
    end,
  })

  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  }, { load = true })

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
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })

  require("treesitter-context").setup()
end)
