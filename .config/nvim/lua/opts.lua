-- Don't show the welcome screen
vim.opt.shortmess:append({ I = true })

-- UI
vim.opt.scrolloff = 3

-- don't show which mode we are in
-- https://github.com/fatih/vim-go/pull/685
vim.opt.showmode = false

vim.opt.completeopt = "menu,noselect,popup,fuzzy"
vim.opt.winborder = "rounded"

vim.opt.wildmode = "list:longest"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.showmatch = true

vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10

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

-- Don't apply editorconfig settings automatically
vim.g.editorconfig = false

-- netrw
vim.g.netrw_banner = 0

-- Vim builtin C parser doesn't like nested initialisers.
-- So stop highlighting my code in red when it compiles fine.
vim.g.c_no_curly_error = 1

-- security
vim.opt.secure = true
vim.opt.modeline = false

vim.opt.makeprg = "./build.sh"

vim.opt.errorformat = {
  "%f:%l:%c: %trror: %m",
  "%f:%l:%c: %tarning: %m",
  "%f:%l:%c: %tote: %m",
  "%f:%l: %trror: %m",
  "%f:%l: %tarning: %m",
  "%-G%.%#",
}
