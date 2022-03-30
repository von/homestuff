" Configuration related to indentation

filetype indent on

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Automatically indent new lines
set smartindent

" Use second line of pargraph for indentation
set formatoptions+=2

" Indentation settings for using 2 spaces instead of tabs.
set shiftwidth=2
set softtabstop=2
set expandtab
set tabstop=8

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
