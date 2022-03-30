" Configuration for GitGutter plugin

" Use colored dots instead of "+/-/etc."
" Kudos: https://github.com/statico/dotfiles/blob/master/.vim/vimrc
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

" Background matches LineNr in ./colors.vim
"   Setting g:gitgutter_override_sign_column_highlight = 0 doesn't seem
"   to work.
highlight GitGutterAdd ctermfg=green ctermbg=236
highlight GitGutterChange ctermfg=yellow ctermbg=236
highlight GitGutterDelete ctermfg=red ctermbg=236
" A changed line followed by at least one removed line
highligh GitGutterChangeDelete ctermfg=136 ctermbg=236

" Hack: update GitGutter whenever we enter a buffer until the autocmd
" communication works between them as it should.
" See: https://github.com/airblade/vim-gitgutter/issues/502#issuecomment-446389662
augroup GitGutterFix
  autocmd!
  autocmd BufEnter * silent! GitGutter
augroup END

" If current file is untracked, stage the whole file.
" Otherwise add stage the current hunk.
" Kudos: https://stackoverflow.com/a/21152503/197789
function GitAddHunkOrFile()
  let file = expand('%')
  let message = system('git ls-files -- ' . file)
  " Check for error. If none, a non-zero length string.
  let is_tracked = (message =~ '^fatal: not a git repositiory') ? 0 : strlen(message)
  if is_tracked
    execute "GitGutterStageHunk"
    echom "Hunk staged"
  else
    execute "Git add " . file
    echom "File staged"
  end
endfunction
