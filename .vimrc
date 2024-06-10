""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" General
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" I used to use altercation/vim-colors-solarized but Neovim 0.10 introduced
" 'set termguicolors' by default, and the old solarized plugin wasn't
" compatible.
Plug 'lifepillar/vim-solarized8', { 'branch': 'neovim' }

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'airblade/vim-rooter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'jmckiern/vim-venter'

" Go
Plug 'fatih/vim-go'

" Lisp
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'Olical/aniseed', { 'branch': 'master' }
Plug 'bakpakin/fennel.vim'
Plug 'Olical/conjure', {'tag': 'v4.13.0'}

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_structs=1
let g:go_fmt_command="goimports"
let g:go_fmt_options = {
  \   "goimports": "-local github.com/monzo",
  \ }
let g:go_version_warning = 0
let g:go_def_mode = "gopls"
let g:go_info_mode = "gopls"

" Fix losing fold state on save
" https://github.com/fatih/vim-go/issues/502
let g:go_fmt_experimental = 1

" :Rooter sets the working directory to the nearest project
let g:rooter_manual_only=1
let g:rooter_patterns=['Makefile', '.git/']

let g:gutentags_cache_dir='~/.vim/gutentags'
let g:gutentags_project_root=['Makefile', '.gutentags']
"set statusline+=%{gutentags#statusline()}

let g:sexp_filetypes = 'clojure,scheme,lisp,fennel'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:solarized_termtrans=1

set background=dark
colorscheme solarized8

" when the screen decides to scroll
set scrolloff=3

" don't show which mode we are in
" https://github.com/fatih/vim-go/pull/685
set noshowmode

" no preview window when omnicompleting
" only insert the longest common match, not just the first one 
" makes it easy to refine the search by typing
set completeopt-=preview
set completeopt+=longest

" tab completion for vim commands
set wildmode=list:longest

" search
set ignorecase
set smartcase
set gdefault
set showmatch

" Cursor
"https://stackoverflow.com/questions/6488683/how-do-i-change-the-vim-cursor-in-insert-normal-mode/30199177
"Ps = 0  -> blinking block.
"Ps = 1  -> blinking block (default).
"Ps = 2  -> steady block.
"Ps = 3  -> blinking underline.
"Ps = 4  -> steady underline.
"Ps = 5  -> blinking bar (xterm).
"Ps = 6  -> steady bar (xterm).
" insert mode
let &t_SI.="\e[5 q"
" replace mode
let &t_SR.="\e[4 q"
" normal mode
let &t_EI.="\e[1 q"

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" folds
set foldmethod=indent
set foldlevelstart=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the pwd to $HOME
cd

set nobackup
set noswapfile

" create undo files
set undofile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" gradle = groovy
au BufNewFile,BufRead *.gradle set filetype=groovy

" wrap lines with sensible line break locations
set wrap
set linebreak

" configure tab and EOL characters in case I :set list
set listchars=tab:▸\ ,eol:¬

" tabs
set expandtab " spaces instead of tabs
set tabstop=2 " width of tabs
set shiftwidth=2 " width of indent commands
set softtabstop=2 " amount of spaces to use and fine-tunes indent/outdent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" easier window split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" resize windows using arrow keys
nnoremap <left> :vertical resize -10<cr>
nnoremap <down> :resize +10<cr>
nnoremap <up> :resize -10<cr>
nnoremap <right> :vertical resize +10<cr>

" treat wrapped lines as new lines
nnoremap j gj
nnoremap k gk

" make Y behave like C or D
nnoremap Y y$

" keep selected text selected when fixing indentation
vnoremap < <gv
vnoremap > >gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
let maplocalleader = "\<space>"
"
" write the current file
nnoremap <leader>w :w<cr>

" type leader + leader to unhiglight
nnoremap <leader><leader> :noh<cr>

" paste from clipboard, alternative to :set paste to avoid fucking up
" indentation
map <leader>v "*p<cr>:exe ":echo 'pasted from clipboard'"<cr>
map <leader>c "*y<cr>:exe ":echo 'copied to clipboard'"<cr>

" remove all trailing whitespace
map <leader>s :%s/\s\+$//e<cr>

" fzf
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>f :Files<CR>

" GoDecl leverages fzf.vim
autocmd FileType go nnoremap <leader>d :GoDecls<CR>
autocmd FileType go nnoremap <leader>i :GoInfo<CR>

" fzf.vim :Rg command to add --multiline and remove smart case
command! -bang -nargs=* Rgm call fzf#vim#grep("rg --multiline --column --line-number --no-heading --color=always -r '$1' -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)
" For debugging
"command! -bang -nargs=* Rg call fzf#vim#grep("rg -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

" Go [M]ethod definitions
autocmd FileType go nnoremap <localleader>m :Rg func\s+\([^\)]+\)\s+<C-R><C-W>\(<CR>
" Go [F]unction definitions
autocmd FileType go nnoremap <localleader>f :Rg func\s+<C-R><C-W>\(<CR>
" Go function or method [C]alls
autocmd FileType go nnoremap <localleader>c :Rg <C-R><C-W>\(<CR>
" Go struct [M]embers
autocmd FileType go nnoremap <localleader>m :Rgm type\s+[A-Za-z]+\s+struct\s+\{(?:\n*[^\}]*)*(\s+<C-R><C-W>\s+)(?:\n*[^\}]*)*\}<CR>
" Go [S]tructs
autocmd FileType go nnoremap <localleader>s :Rg type\s+<C-R><C-W>\s+struct<CR>
" Go [I]interfaces
autocmd FileType go nnoremap <localleader>i :Rg type\s+<C-R><C-W>\s+interface<CR>

autocmd FileType fennel setlocal equalprg=fnlfmt\ -

" vim-rooter sets the vim pwd to the nearest project
nnoremap <leader>r :Rooter<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Usuful key mappings I always forget
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :so % to reload the .vimrc (:source the current file)
" :cd %:h to change the pwd to the current file directory
" CTRL+SHIFT+6: toggle between last two buffers
" CTRL+W R: rotate buffers (swap two buffers)
" :GoImpl io.ReadWriteCloser when you're on top of a type
" :GoAddTags
" :GoFillStruct to add all struct fields with their default value
" :GoKeyify to add keys to Go structs
" :redraw! to clear the screen and redraw vim
" CTRL+R CTRL+W to insert the word under the cursor in ex mode
