" Options related to user interface
"
" Assumes 256 colors:
" http://vim.wikia.com/wiki/256_colors_in_vim
"

" Manually set this as it seems to get set to reset
" when called from vim/tig/vim.
set encoding=utf-8

" Enable use of the mouse for all modes
set mouse=a

" Don't use Mac system clipboard by default
"   It can be accessed through '+' - e.g. "+yy or "+pp
" Set clipboard to "unnamed" to make system the default per:
"   http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard="none"

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Make whitespace visible
" Requires encoding=utf-8
set list listchars=tab:⋅⋅,trail:⋅,nbsp:⋅

" Prefix for wrapped lines
" This interfers with cut'n'paste
"set showbreak=↪

" set formatoptions {{{

" Automatically wrap comments (using textwidth)
set formatoptions+=c

" Automatically insert comment leader on new line
set formatoptions+=r
set formatoptions+=o

" Allow formatting of comments with 'gq'
set formatoptions+=q

" Remove comment leaders when joining lines
set formatoptions+=j

" }}} set formatoptions

" linebreak tells Vim to only wrap at a character in the 'breakat' option
" (Basically, word boundaries, so turn this on for text modes.)
set nolinebreak

" Show partial commands in the last line of the screen
set showcmd

" Show matching bracket when closing
set showmatch

" Display line numbers on the left
set number

" Keep this many lines on screen past cursor when scrolling
set scrolloff=5

" Do not have git-gutter highlight lines
let g:gitgutter_highlight_lines = 0
