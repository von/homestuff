" Folding configuration

" Enable folding for shell scripts
" Value is OR of functions (1), heredoc (2) and if/do/for (4)
let g:sh_fold_enabled = 7

" Augment the default foldtext() with an indicator of whether the folded
" lines have been changed.
set foldtext=gitgutter#fold#foldtext()
