if exists("syntax_on")
  syntax reset
endif

highlight clear

" Use terminal colors - make Normal explicitly empty
highlight Normal ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE

" Only highlight comments using terminal color palette
highlight Comment ctermfg=2
highlight! link @comment Comment

" Force all syntax groups to have no color at all
highlight String NONE
highlight Number NONE  
highlight Identifier NONE
highlight Function NONE
highlight Statement NONE
highlight Type NONE
highlight Special NONE
highlight Constant NONE
highlight PreProc NONE
highlight Operator NONE
highlight Delimiter NONE
highlight Keyword NONE

" Clear Treesitter groups
highlight @string NONE
highlight @number NONE
highlight @variable NONE
highlight @function NONE
highlight @keyword NONE
highlight @type NONE
highlight @constant NONE
highlight @property NONE
highlight @operator NONE
highlight @punctuation NONE
highlight @constructor NONE
highlight @boolean NONE
highlight @character NONE

" Clear additional common groups
highlight Boolean NONE
highlight Character NONE
highlight Float NONE
highlight Label NONE
highlight Repeat NONE
highlight Conditional NONE
highlight Exception NONE
highlight Include NONE
highlight Define NONE
highlight Macro NONE
highlight StorageClass NONE
highlight Structure NONE
highlight Typedef NONE
highlight Tag NONE
highlight SpecialChar NONE
highlight SpecialComment NONE
highlight Debug NONE

" fzf-lua specific highlight groups
highlight FzfLuaCursorLine cterm=reverse gui=reverse
highlight FzfLuaCursorLineNr cterm=reverse gui=reverse
