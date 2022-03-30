" Configuration for .cfg files

" Set up folds for each section
function! CFGFoldExpr()
  let thisline = getline(v:lnum)
  if match(thisline, '^\[') >= 0
    return ">1"
  elseif match(thisline, '^$') >= 0
    return "0"
  else
    return "="
endfunction

function! CFGFoldText()
  if foldexpr != 'CFGFoldExpr()' then
    " In case foldexpr has been changed, then use standard foldtext()
    return foldtext()
  endif
  let eventline = getline(v:foldstart)
  return eventline
endfunction

setlocal foldmethod=expr
let &l:foldexpr = 'CFGFoldExpr()'
let &l:foldtext = 'CFGFoldText()'
