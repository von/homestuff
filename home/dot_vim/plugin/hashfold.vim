" Fold functions for files using hashes for comments
"
" Use '#######+" (7+ hashes) followed by title to indicate first-level fold
" Use '######" (6 hashes) followed by title to indicate second-level fold
" Use '#------+' (hash followed by 6+ dashes) to close all folds
" Use '#-----' (hash followed by 5 dashes) to close second-level fold

" Call this function to set up Hashfolding: call HashFold
" Meant to be invoked in a ftplugin file
function! HashFold()
  setlocal foldmethod=expr
  let &l:foldexpr =  'HashFoldExpr()'
  let &l:foldtext =  'HashFoldText()'
endfunction

function! HashFoldExpr()
  let thisline = getline(v:lnum)
  if match(thisline, '^#\{7,}') >= 0
    return ">1"
  elseif match(thisline, '^#\{6}') >= 0
    return ">2"
  elseif match(thisline, '^#-\{7,}') >= 0
    return "0"
  elseif match(thisline, '^#-\{5}') >= 0
    return "s1"
  else
    return "="
endfunction

function! HashFoldText()
  if &foldexpr != 'HashFoldExpr()'
    " In case foldexpr has been changed, then use standard foldtext()
    return foldtext()
  endif
  let titleline = getline(v:foldstart + 1)
  let title = substitute(titleline, '^#\+\s*', '', '')
  let indent = repeat('#', v:foldlevel)
  let foldsize = (v:foldend - v:foldstart)
  let linecount = '['.foldsize.' line'.(foldsize>1?'s':'').']'
  return indent . ' ' . linecount . ' ' . title
endfunction
