" Allow for reload of vimrc
"
" See following for autocmd guards
" http://stackoverflow.com/questions/15353988/progressively-slower-reloading-time-of-vimrc

function! ReloadVIMRC()
  source $MYVIMRC
  if filereadable($MYGVIMRC)
    source $MYGVIMRC
  endif
  redraw!
endfunction
