" Options

" Time after keystroke to write swap file. Set this to be low so GitGutter
" plugin updates quickly.
set updatetime=100

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Automatically change to directory of file in current buffer
" This is disabled because I found it didn't work reliably for me and I use
" ../plugin/AutoCD.vim instead.
set noautochdir

" /bin/sh is an alias for bash
let g:is_bash=1

" Better command-line completion
set wildmenu

" Disable modeline and let securemodelines bundle take care of this
set nomodeline

" Turn on verbose output from securemodelines
let g:secure_modelines_verbose=1

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Look for tags in current directory or parent (and on up)
" Use C-] to jump to tag under cursor
set tags=./tags;/

if !has('nvim')
  " Use blowfish instead of zip with vim's native encryption (see ':X')
  set cryptmethod=blowfish
endif

" Don't give me an error if a swapfile is present when editing a file
" Kudos: http://stackoverflow.com/a/1588848/197789
set shortmess+=A

" Automatically read a file if it has changed
set autoread

" Don't show swap when browsing files (e.g. netrw, ctrlspace)
" Note that vim-vinegar overrides netrw_list_hide with contents of
" wildignore, so use it instead.
"let g:netrw_list_hide= '.*\.swp$,.*\.swo$'
set wildignore+=*.swp
set wildignore+=*.swo
