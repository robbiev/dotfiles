return {
  filetypes = { "go", "gomod", "gowork", "gosum" },
  cmd = { "gopls" },
  root_dir = function(buf, callback)
    local root = vim.fs.root(buf, { "go.mod" })
    if not root then
      callback(nil)
      return
    end
    local workspace = vim.fs.root(root, { "go.work" })
    if workspace then
      callback(workspace)
      return
    end
    callback(root)
  end,
}
