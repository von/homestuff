" Set CursorLine appearance
" Kudos: http://vim.wikia.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode

set cursorline

" XXX This doesn't seem to be working
function! SetCursorLineColor(mode)
  if a:mode == 'i'  " Insert mode
    hi link CursorLineNr CursorLineNrInsert
  elseif a:mode == 'r'  " Replace mode
    hi link CursorLineNr CursorLineNrReplace
  elseif a:mode == 'v'  " Virtual Replace mode (gr/gR)
    hi link CursorLineNr CursorLineNrVirtual
  else " Not in insert mode
    hi link CursorLineNr CursorLineNrNormal
  endif
endfunction

augroup SetCursorLine
  au!
  au InsertEnter * call SetCursorLineColor(v:insertmode)
  au InsertChange * call SetCursorLineColor(v:insertmode)
  au InsertLeave * call SetCursorLineColor("-")
augroup END

" Only highlight CursorLine in current buffer
" Kudos: http://stackoverflow.com/a/12018552/197789
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Set default for start up
call SetCursorLineColor("-")
