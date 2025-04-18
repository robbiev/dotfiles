vim.cmd("syntax off")

require("keymap")
require("opts")
require("autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  local_spec = false,
})

vim.lsp.enable({ "gopls", "zls" })

vim.diagnostic.config({
  signs = false, -- Disable the signs in the gutter/sign column
  virtual_text = { current_line = true },
})
