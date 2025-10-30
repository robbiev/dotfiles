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

-- duplicate line maintaining column position
vim.keymap.set("n", "<leader>d", ":copy.<CR>", { noremap = true })

-- Delete into the black hole register to avoid clobbering the default register.
--vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]])

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

-- Go to tag, and show a list of tags if multiple match
vim.keymap.set("n", "<leader><CR>", "g<C-]>zz", { noremap = true })
-- Go to tag
vim.keymap.set("n", "<CR>", function()
  -- Only apply ctag navigation to normal file buffers
  if vim.bo.buftype == "" then
    vim.cmd("normal! \x1d") -- Execute <C-]>
    vim.cmd("normal! zz") -- Center the screen
  else
    -- In special buffers (qf, oil, etc.), use default <CR>
    vim.cmd("normal! \r") -- Execute <CR>
  end
end, { noremap = true })

-- Go to tag in vertical split
vim.keymap.set("n", "gt", "<C-w>v<C-]>zz", { noremap = true })
-- Go back from tag nativation
vim.keymap.set("n", "<BS>", "<C-t>zz", { noremap = true })

local function async_make()
  local lines = {}
  local makeprg = vim.fn.expandcmd(vim.o.makeprg)

  print("Building...")

  vim.fn.jobstart(makeprg, {
    on_stdout = function(_, data)
      vim.list_extend(lines, data)
    end,
    on_stderr = function(_, data)
      vim.list_extend(lines, data)
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        vim.fn.setqflist({}, "r", {
          lines = lines,
          efm = vim.o.errorformat,
        })

        if #vim.fn.getqflist() == 0 then
          print("Build succeeded")
        else
          print("Build failed")
        end
      end)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

vim.keymap.set("n", "<leader>mr", async_make, {})

local function gdb_breakpoint_and_launch(filepath, line_number)
  local gdb_commands = "start"
  if filepath and string.len(filepath) > 0 then
    gdb_commands = string.format("tbreak %s:%d", filepath, line_number)
    gdb_commands = gdb_commands .. "\nrun\n"
  end

  -- Write to .gdb_scratch file in current directory
  local gdb_file = vim.fn.getcwd() .. "/.gdb_scratch"
  local file = io.open(gdb_file, "w")
  if file then
    file:write(gdb_commands)
    file:close()
  else
    vim.notify("Failed to create .gdb_scratch file", vim.log.levels.ERROR)
    return
  end

  -- Launch Ghostty
  local gdb_cmd = "ghostty -e sh -c './build.sh gdbscratch'"
  vim.fn.jobstart(gdb_cmd, { detach = true })

  vim.notify("Debugger launched", vim.log.levels.INFO)
end

local function gdb_breakpoint_on_line_and_launch()
  -- Get current buffer information
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_number = cursor[1]
  gdb_breakpoint_and_launch(filepath, line_number)
end

vim.keymap.set("n", "<leader>mm", gdb_breakpoint_and_launch, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ml", gdb_breakpoint_on_line_and_launch, { noremap = true, silent = true })

-- Open netrw
-- vim.keymap.set("", "-", vim.cmd.Ex)

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
