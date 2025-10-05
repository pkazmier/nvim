local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
now_if_args(function() -- treesitter
  vim.api.nvim_create_autocmd({ "PackChanged" }, {
    pattern = "*/nvim-treesitter",
    callback = function(ev)
      if ev.data.kind == "install" or ev.data.kind == "update" then
        if vim.fn.exists(":TSUpdate") > 0 then
          vim.cmd("TSUpdate")
        end
      end
    end,
  })

  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  }, { load = true })

  local ensure_installed = {
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
  require("nvim-treesitter").install(ensure_installed)
  local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
  vim.list_extend(filetypes, { "markdown", "pandoc" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })

  require("treesitter-context").setup()
end)
