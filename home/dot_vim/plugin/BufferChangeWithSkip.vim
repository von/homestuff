" BufferChangeWithSkip, NextBuffer and PrevBuffer functions
"
" Allow changing buffers with a list of buffers to skip.

" List of buffers to skip
let g:skip_buffers = ['^$']

function! BufferChangeWithSkip(cmd)
  let l:starting_bufnr = bufnr("%")
  while 1
    try
      execute a:cmd
    catch /E85:/
      echo "No other buffer to visit"
      break
    endtry
    if l:starting_bufnr == bufnr("%")
      " Looped back around to the start
      echo "No other buffer to visit"
      break
    endif
    for ex in g:skip_buffers
      if match(bufname("%"), ex) > -1
        continue
      endif
    endfor
    " Successfully changed to buffer that didn't match
    break
  endwhile
endfunction

" Go to next buffer not on in skip_buffers
function! NextBuffer()
  call BufferChangeWithSkip(":bnext")
endfunction

" Go to previous buffer not on in skip_buffers
function! PrevBuffer()
  call BufferChangeWithSkip(":bprev")
endfunction
