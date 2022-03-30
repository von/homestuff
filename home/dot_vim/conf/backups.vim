" Enable backups in centralized place

silent !mkdir ~/.vim-local/backups/ > /dev/null 2>&1

set backup " make backup files
set backupdir=~/.vim-local/backups/ " where to put backup files

" Don't backup files in our $TMPDIR
" Macs also see to use temporary files with a /private/ prefix
let &backupskip = &backupskip . ',' . '/private' . expand('$TMPDIR') . "*"
