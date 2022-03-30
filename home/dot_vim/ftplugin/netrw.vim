" Key maps for netrw, which does buffer only remaps
" Kudos: http://unix.stackexchange.com/a/42939/29832

" Bind 'h' and 'H' to help as I expect
noremap <buffer> h :help netrw-browse-maps<cr>
noremap <buffer> H :help netrw<cr>

" Return to file being edited before the explorer was entered.
" Kudos: http://stackoverflow.com/a/29868056/197789
noremap <buffer> Q :bdelete<cr>
