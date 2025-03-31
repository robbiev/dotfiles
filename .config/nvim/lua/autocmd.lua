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
  pattern = "swift",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    client.server_capabilities.document_formatting = false

    local opts = { noremap = true, silent = true }

    vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-Space>", "<C-x><C-o>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<F1>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  end,
})
