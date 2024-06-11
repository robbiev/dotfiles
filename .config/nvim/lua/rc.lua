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

-- Files
-- set the pwd to $HOME
vim.cmd [[cd]]

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true

local augroup = vim.api.nvim_create_augroup("robbiev", {clear = true})

-- Buffers
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  group = augroup,
  pattern = "*.gradle",
  callback = function()
    vim.opt.filetype = "groovy"
  end
})

 -- wrap lines with sensible line break locations
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.listchars = "tab:▸\\ ,eol:¬"

-- Tabs
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.tabstop = 2 -- width of tabs
vim.opt.shiftwidth = 2 -- width of indent commands
vim.opt.softtabstop = 2 -- amount of spaces to use, and fine-tune indent/outdent

-- General key mappings

-- easier window split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", {noremap = true})
vim.keymap.set("n", "<C-j>", "<C-w>j", {noremap = true})
vim.keymap.set("n", "<C-k>", "<C-w>k", {noremap = true})
vim.keymap.set("n", "<C-l>", "<C-w>l", {noremap = true})

-- Resize windows using arrow keys
vim.keymap.set("n", "<left>", ":vertical resize -10<cr>", {noremap = true})
vim.keymap.set("n", "<down>", ":resize +10<cr>", {noremap = true})
vim.keymap.set("n", "<up>", ":resize -10<cr>", {noremap = true})
vim.keymap.set("n", "<right>", ":vertical resize +10<cr>", {noremap = true})

-- Treat wrapped lines as new lines
vim.keymap.set("n", "j", "gj", {noremap = true})
vim.keymap.set("n", "k", "gk", {noremap = true})

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$", {noremap = true})

-- Keep selected text selected when fixing indentation
vim.keymap.set("v", "<", "<gv", {noremap = true})
vim.keymap.set("v", ">", ">gv", {noremap = true})

--
-- Leader key mappings
--
vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- Write the current file
vim.keymap.set("n", "<leader>w", ":w<cr>", {noremap = true})

-- Type leader + leader to unhighlight
vim.keymap.set("n", "<leader><leader>", ":noh<cr>", {noremap = true})

-- Paste from clipboard, alternative to :set paste to avoid messing up indentation
vim.keymap.set("", "<leader>v", [["*p<cr>:exe ":echo \'pasted from clipboard\'"<cr>]], {})
vim.keymap.set("", "<leader>c", [["*y<cr>:exe ":echo \'copied to clipboard\'"<cr>]], {})

-- Remove all trailing whitespace
vim.keymap.set("", "<leader>s", ":%s/\\s\\+$//e<cr>", {})

-- fzf mappings
vim.keymap.set("n", "<leader>b", ":Buffers<CR>", {noremap = true})
vim.keymap.set("n", "<leader>t", ":Tags<CR>", {noremap = true})
vim.keymap.set("n", "<leader>f", ":Files<CR>", {noremap = true})

-- Go mappings. GoDecl leverages fzf.vim.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>d", ":GoDecls<CR>", {noremap = true})
    vim.keymap.set("n", "<leader>i", ":GoInfo<CR>", {noremap = true})
  end
})

-- vim-rooter sets the vim pwd to the nearest project
vim.keymap.set("n", "<leader>r", ":Rooter<CR>", {noremap = true})

--
-- Usuful key mappings I always forget
--
-- :so % to reload the .vimrc (:source the current file)
-- :cd %:h to change the pwd to the current file directory
-- CTRL+SHIFT+6: toggle between last two buffers
-- CTRL+W R: rotate buffers (swap two buffers)
-- :GoImpl io.ReadWriteCloser when you're on top of a type
-- :GoAddTags
-- :GoFillStruct to add all struct fields with their default value
-- :GoKeyify to add keys to Go structs
-- :redraw! to clear the screen and redraw vim
-- CTRL+R CTRL+W to insert the word under the cursor in ex mode
