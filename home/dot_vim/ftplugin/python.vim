" ftplugin for python mode

" Python configuration: tab inserts 4 spaces
setlocal shiftwidth=4 softtabstop=4

" Color column 80
setlocal colorcolumn=80

" Have docstrings work as expected with DelimitMate
let b:delimitMate_nesting_quotes = ['"']

if exists('*NeoCompleteLock')
  " Turn off automatic completion as its too distracting.
  :NeoCompleteLock
endif

" Keybindings using "<leader>m" prefix
" See also ../conf/python-mode.vim
nmap <leader>ml :PymodeLint<cr>
