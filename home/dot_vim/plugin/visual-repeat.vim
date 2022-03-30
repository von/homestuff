" Enable repeating actions over Visual line selction
" Kudos: https://github.com/nelstrom/dotfiles/blob/master/vimrc 

xnoremap . :normal .<CR>
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
