set nocompatible
filetype off

" vundle setup
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'scrooloose/syntastic'
Bundle 'guns/vim-clojure-static'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'juvenn/mustache.vim'

if has('unix')
    language messages C
else
    language messages en
endif
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
endif
if !has('gui_running')
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
endif
set background=dark
colorscheme solarized

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
" create undo files
set undofile
set undodir=~/.vim/tmp

" in case those dirs don't exist
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" wrap lines, and not just on any character
set wrap
set linebreak
set textwidth=80
" configure tab and EOL characters in case I :set list
set listchars=tab:▸\ ,eol:¬

" when the screen decides to scroll
set scrolloff=3
" show position in the file
set ruler
" have fast terminal, no slowness
set ttyfast
" always show status bar
set laststatus=2
" show and save everything as utf-8
set encoding=utf-8
set fileencoding=utf-8

" highlight current line
"set cursorline
"set cursorcolumn
"
" tab completion for vim commands
set wildmenu
set wildmode=list:longest

" enable unsaved buffers
set hidden
" start new lines at same indetation
set autoindent
" show which mode we are in
set showmode
" show the command we are currently typing and visual selection lenghts
set showcmd
" file type + indent detection
filetype plugin indent on
" rainbow parens for clojure
au VimEnter *.clj RainbowParenthesesToggle
au Syntax *.clj RainbowParenthesesLoadRound
au Syntax *.clj RainbowParenthesesLoadSquare
au Syntax *.clj RainbowParenthesesLoadBraces

" tabs
set expandtab " spaces instead of tabs
set tabstop=2 " width of tabs
set shiftwidth=2 " width of indent commands
set softtabstop=2 " amount of spaces to use and fine-tunes indent/outdent
" backspace across newlines
set backspace=indent,eol,start

" relative line numbers
set rnu
" syntax highlighting
syntax on

" no beeping or screen flashing
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" tame searches
set ignorecase
" be smart about when to be case sensitive
set smartcase
" adds /g by default
set gdefault
set incsearch
set showmatch
set hlsearch

" accidentally pressing help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" tab = %
nnoremap <tab> %
vnoremap <tab> %
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

" leader = space
let mapleader = "\<space>"

" type space + space to unhiglight
nnoremap <leader><space> :noh<cr>

" paste from clipboard, alternative to :set paste to avoid fucking up
" indentation
map <leader>v "*p<cr>:exe ":echo 'pasted from clipboard'"<cr>
map <leader>c "*y<cr>:exe ":echo 'copied to clipboard'"<cr>

" remove all trailing whitespace
map <leader>s :%s/\s\+$//e<cr>

" added for syntastic
nnoremap <leader>j :lnext<cr>
nnoremap <leader>k :lprev<cr>
