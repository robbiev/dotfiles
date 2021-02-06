set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Enable writing neovim config in Fennel
lua require('aniseed.env').init()
