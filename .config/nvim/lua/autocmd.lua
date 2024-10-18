local augroup = vim.api.nvim_create_augroup("robbiev", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  pattern = "*.gradle",
  callback = function()
    vim.opt.filetype = "groovy"
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
