local augroup = vim.api.nvim_create_augroup("robbiev", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  pattern = "*.gradle",
  callback = function()
    vim.opt.filetype = "groovy"
  end,
})

-- Go mappings. GoDecl leverages fzf.vim.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<localleader>d", ":GoDecls<CR>", { noremap = true })
    vim.keymap.set("n", "<localleader>i", ":GoInfo<CR>", { noremap = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "swift",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    vim.cmd(":Rooter")
  end,
})
