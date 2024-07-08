-- easier window split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Resize windows using arrow keys
vim.keymap.set("n", "<left>", ":vertical resize -10<cr>", { noremap = true })
vim.keymap.set("n", "<down>", ":resize +10<cr>", { noremap = true })
vim.keymap.set("n", "<up>", ":resize -10<cr>", { noremap = true })
vim.keymap.set("n", "<right>", ":vertical resize +10<cr>", { noremap = true })

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
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$", { noremap = true })

-- Keep the cursor in place while joining lines
-- Set a mark called z, join lines, go back to the mark
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

-- Keep selected text selected when fixing indentation
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Center on the current line after jumping
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Move selected line(s) up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--
-- Leader key mappings
--
vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- Delete into the black hole register to avoid clobbering the default register.
vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]])

-- In visual mode, delete into the black hole register and paste
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Write the current file
vim.keymap.set("n", "<leader>w", ":w<cr>", { noremap = true })

-- Type leader + leader to unhighlight
vim.keymap.set("n", "<leader><leader>", ":noh<cr>", { noremap = true })

-- Interact with system clipboard
vim.keymap.set("", "<leader>c", [["+y]])
vim.keymap.set("", "<leader>v", [["+p]])

-- Remove all trailing whitespace
vim.keymap.set("", "<leader>s", ":%s/\\s\\+$//e<cr>", {})

-- Go to current file directory
vim.keymap.set("", "<leader>R", ":cd %:h<cr>", {})

-- Open netrw
vim.keymap.set("", "-", vim.cmd.Ex)

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
