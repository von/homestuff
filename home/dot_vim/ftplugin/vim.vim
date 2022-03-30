" vim file mode (e.g. for .vimrc)

" vimrc uses markers for folding
setlocal foldmethod=marker

" Source current file with 'ms'
:map <leader>ms :source %<cr>:redraw!<cr>:echo "Sourced"<cr>

" Color column 80
setlocal colorcolumn=80
