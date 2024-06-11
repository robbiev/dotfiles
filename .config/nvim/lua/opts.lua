-- UI
vim.opt.scrolloff = 3

-- don't show which mode we are in
-- https://github.com/fatih/vim-go/pull/685
vim.opt.showmode = false

-- no preview window when omnicompleting
-- only insert the longest common match, not just the first one 
-- makes it easy to refine the search by typing
vim.opt.completeopt = "menu,longest"
vim.opt.wildmode = "list:longest"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.showmatch = true

vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10

-- Folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 1

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true

 -- wrap lines with sensible line break locations
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.listchars = "tab:▸\\ ,eol:¬"

-- Tabs
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.tabstop = 2 -- width of tabs
vim.opt.shiftwidth = 2 -- width of indent commands
vim.opt.softtabstop = 2 -- amount of spaces to use, and fine-tune indent/outdent

