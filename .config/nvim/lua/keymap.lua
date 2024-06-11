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

-- Hack to push the buffer text to the right when editing files on a large monitor.
-- This is a simple alternative to various zen mode plugins.
-- It works for me because I don't use line numbers or anything like that.
vim.keymap.set("", "<localleader><right>", function()
  vim.opt.statuscolumn = vim.opt.statuscolumn:get() .. string.rep(" ", 16)
end)
vim.keymap.set("", "<localleader><left>", function()
  -- start from the first character and end on the 9th last character
  vim.opt.statuscolumn = vim.opt.statuscolumn:get():sub(1, -17)
end)
vim.keymap.set("", "<localleader><down>", function()
  vim.opt.statuscolumn = ""
end)

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

-- Interact with system clipboard
vim.keymap.set("", "<leader>c", [["+y]])
vim.keymap.set("", "<leader>v", [["+p]])

-- Remove all trailing whitespace
vim.keymap.set("", "<leader>s", ":%s/\\s\\+$//e<cr>", {})

-- Go to current file directory
vim.keymap.set("", "<leader>R", ":cd %:h<cr>", {})

-- Open netrw
vim.keymap.set("", "<leader>x", vim.cmd.Ex)

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
