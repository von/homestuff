" Debug syntax
" Print highlight group of text under cursor
" Kudos: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
