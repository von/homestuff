"Enable persistent undo
"Kudos: http://stackoverflow.com/questions/5700389/using-vims-persistent-undoo

silent !mkdir ~/.vim-local/undo/ > /dev/null 2>&1

set undodir=~/.vim-local/undo/
set undofile
