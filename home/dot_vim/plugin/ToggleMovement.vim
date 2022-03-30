" ToggleMovement(Op1, Op2, ...)
" Try operations until one causes the cursor to move, then return
"
" Note that ops dosn't technically need to be a movement.
" I added 'silent!' so I could safely try toggling folds.
"
" Kudos: http://ddrscott.github.io/blog/2016/vim-toggle-movement/

function! ToggleMovement(...)
  let pos = getpos('.')
  for op in a:000
    execute "silent! normal! " . op
    if pos != getpos('.')
      break
    endif
  endfor
endfunction
