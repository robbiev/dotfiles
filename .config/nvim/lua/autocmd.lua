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

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "go",
  callback = function()
    -- GoDef based go to definition
    vim.api.nvim_set_keymap("n", "gd", "", {
      noremap = true,
      silent = true,
      callback = function()
        -- Call godef.
        local file_src_path_abs = vim.fn.expand("%:p")
        local file_src_line = vim.fn.line(".")
        local file_src_col = vim.fn.col(".")
        local file_src_byte_offset = vim.fn.line2byte(file_src_line) + file_src_col - 1
        local godef_out = vim.fn.system(
          "godef -new-implementation=false -f "
            .. vim.fn.shellescape(file_src_path_abs)
            .. " -o "
            .. file_src_byte_offset
        )

        -- Parse godef output.
        -- Use g + ctrl-g to print byte offsets in vim for testing
        local file_dst_path_abs, file_dst_line, file_dst_col = string.match(godef_out, "([^:]+):(%d+):(%d+)")

        -- Jump to the destination.
        vim.cmd("e " .. file_dst_path_abs)
        vim.fn.setpos(".", { vim.api.nvim_get_current_buf(), tonumber(file_dst_line), tonumber(file_dst_col), 0 })
        vim.cmd("normal! zz")
      end,
    })
  end,
})
