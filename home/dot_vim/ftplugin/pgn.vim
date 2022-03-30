" Configuration for .pgn files

" Set up folds for each game
" Assumes first line of a game is '[Event "<event name>"]'
function! PGNFoldExpr()
  let thisline = getline(v:lnum)
  if match(thisline, '^\[Event ') >= 0
    return ">1"
  else
    return "="
endfunction

function! PGNFoldText()
  if &foldexpr != 'PGNFoldExpr()'
    " In case foldexpr has been changed, then use standard foldtext()
    return foldtext()
  endif
  let eventline = getline(v:foldstart)
  " Kudos: https://unix.stackexchange.com/a/400374/29832
  " \zs and \ze set start and end of returned match
  return "# " . matchstr(eventline, '"\zs[^"]\+\ze"')
endfunction

setlocal foldmethod=expr
let &l:foldexpr = 'PGNFoldExpr()'
let &l:foldtext = 'PGNFoldText()'
