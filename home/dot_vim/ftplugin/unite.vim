" Unite buffer

" Close unite with C-c
imap <buffer> <C-c> <Plug>(unite_exit)

" Enable navigation with C-j and C-k in insert mode
" Kudos: http://www.codeography.com/2013/06/17/replacing-all-the-things-with-unite-vim.html
imap <buffer> <C-j> <Plug>(unite_select_next_line)
imap <buffer> <C-k> <Plug>(unite_select_previous_line)

" Enable navigation with <Down> and <Up> in insert mode
" The following require <esc> not to be bound
imap <buffer> <Down> <Plug>(unite_select_next_line)
imap <buffer> <Up> <Plug>(unite_select_previous_line)
