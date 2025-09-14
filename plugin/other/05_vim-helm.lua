local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
now_if_args(function() -- vim-helm
  vim.pack.add({ "https://github.com/towolf/vim-helm" }, { load = true })
end)
