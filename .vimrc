set nocompatible
filetype off

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'fatih/vim-go'
Plug 'airblade/vim-rooter'
Plug 'ludovicchabant/vim-gutentags'

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_structs=1
let g:go_fmt_command="goimports"

" :Rooter sets the working directory to the nearest project
let g:rooter_manual_only=1
let g:rooter_patterns=['Makefile', '.git/']

let g:gutentags_cache_dir='~/.vim/gutentags'
let g:gutentags_project_root=['Makefile', '.gutentags']
set statusline+=%{gutentags#statusline()}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  if has("gui_macvim")
    set guifont=Monaco:h13
  elseif has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_win32")
    " maximize window
    au GUIEnter * simalt ~x
    " remove toolbar
    set guioptions-=T
    set guifont=Consolas:h12:cANSI
  endif
else
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
endif

" no beeping or screen flashing
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set background=dark
colorscheme solarized

" syntax highlighting
syntax on

" have fast terminal, no slowness
set ttyfast

" when the screen decides to scroll
set scrolloff=3

" show position in the file
set ruler

" always show status bar
set laststatus=2

" don't show which mode we are in
" https://github.com/fatih/vim-go/pull/685
set noshowmode

" show the command we are currently typing and visual selection lenghts
set showcmd

" no preview window when omnicompleting
" only insert the longest common match, not just the first one 
" makes it easy to refine the search by typing
set completeopt-=preview
set completeopt+=longest

" tab completion for vim commands
set wildmenu
set wildmode=list:longest

" search
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the pwd to $HOME
cd

set nobackup
set noswapfile

" create undo files
set undofile
set undodir=~/.vim/tmp

" in case those dirs don't exist
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif

" show and save everything as utf-8
set encoding=utf-8
set fileencoding=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file type + indent detection
filetype plugin indent on

" gradle = groovy
au BufNewFile,BufRead *.gradle set filetype=groovy

" wrap lines with sensible line break locations
set wrap
set linebreak

" configure tab and EOL characters in case I :set list
set listchars=tab:▸\ ,eol:¬

" enable unsaved buffers
set hidden

" start new lines at same indetation
set autoindent

" tabs
set expandtab " spaces instead of tabs
set tabstop=2 " width of tabs
set shiftwidth=2 " width of indent commands
set softtabstop=2 " amount of spaces to use and fine-tunes indent/outdent
set backspace=indent,eol,start " backspace across newlines

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" accidentally pressing help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

" type leader + leader to unhiglight
nnoremap <leader><leader> :noh<cr>

" paste from clipboard, alternative to :set paste to avoid fucking up
" indentation
map <leader>v "*p<cr>:exe ":echo 'pasted from clipboard'"<cr>
map <leader>c "*y<cr>:exe ":echo 'copied to clipboard'"<cr>

" remove all trailing whitespace
map <leader>s :%s/\s\+$//e<cr>

" added for syntastic
nnoremap <leader>j :lnext<cr>
nnoremap <leader>k :lprev<cr>

" fzf
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>f :Files<CR>
" GoDecl leverages fzf.vim
autocmd FileType go nnoremap <Leader>d :GoDecls<CR>

" vim-rooter sets the vim pwd to the nearest project
nnoremap <Leader>r :Rooter<CR>

" tmux: repeat the last command in pane 1 (right pane in vert split)
nnoremap <Leader>k :call system('for pane in $(tmux run "echo #{session_name}:#{window_index}.1"); do tmux send-keys -t $pane C-p C-j; done') <CR> <CR>

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
