" MouseFocusHack.vim
"
" When regains focus with a mouse click, don't move the cursor
" based on that click.
" Kudos: https://vi.stackexchange.com/a/15982/2881

augroup MouseHack
  autocmd!
  autocmd FocusLost * set mouse=
  autocmd FocusGained * call timer_start(200, 'ReenableMouse')
augroup END

function ReenableMouse(timer_id)
  set mouse=a
endfunction
