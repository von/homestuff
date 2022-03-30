" Map left and right to open and close folds
" These bindings let me easly open and close fold with left and right.
" The behavior is close to what vim foes with 'foldopen'/'fdo' but
" adds moving to column 1 on fold opening and working at last column
" in the line (i.e. the cursor doesn't have to move to work).

nnoremap <silent> h :call LeftHandleFold("h")<CR>
nnoremap <silent> <left> :call LeftHandleFold("\<lt>left>")<CR>

" If we move left while on a closed fold, open it and put cursor on column 1
" If we move left in an open fold and we're at column 1, close it.
function! LeftHandleFold(cmd)
  if foldlevel(".") == 0
    " Not in a fold, behave normally
    execute "normal! " . a:cmd
  else
    if foldclosed(".") == -1
      let pos = getpos('.')
      execute "normal! " . a:cmd
      if pos == getpos('.')
        silent! normal! zc
      endif
    else
        silent! normal! zo0
    endif
  endif
endfunction

nnoremap <silent> l :call RightHandleFold("l")<CR>
nnoremap <silent> <right> :call RightHandleFold("\<lt>right>")<CR>

" If we move right while on a closed fold, open it and put cursor on column 1
function! RightHandleFold(cmd)
  if foldclosed(".") == -1
    execute "normal! " . a:cmd
  else
    normal! zo0
  endif
endfunction
