if has('unix')
    language messages C
else
    language messages en
endif
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_win32")
    colorscheme desert
    " maximize window
    au GUIEnter * simalt ~x
    " remove toolbar
    set guioptions-=T 
    set guifont=Consolas:h12:cANSI
  endif
endif

"set backup
"set backupdir=~/.vim/backup
"set directory=~/.vim/tmp

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
" create undo files
set undofile
" highlight current line
"set cursorline
"set cursorcolumn
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

" tabs
set expandtab " spaces instead of tabs
set tabstop=2 " width of tabs
set shiftwidth=2 " width of indent commands
set softtabstop=2 " fine-tunes indent/outdent
" backspace across newlines
set backspace=indent,eol,start

" no vi compat
set nocompatible
" relative line numbers
set rnu
" syntax highlighting
syntax on
" accidentally pressing help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
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
" type \ + space to unhiglight
nnoremap <leader><space> :noh<cr>
" tab = %
nnoremap <tab> %
vnoremap <tab> %
