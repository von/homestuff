" GIT commits

" Disable modelines in GIT commits to parsing commit messages with
" 'git --amend'
" Kudos: http://www.dreamind.de/cgi-bin/gitweb.cgi?p=configurations.git;a=commitdiff_plain;h=8bfd2c81b8bbcf79dec9771daf7ac2cb57fe12ce
" XXX This doesn't disable securemodelines
setlocal nomodeline
let b:disable_secure_modelines = 1

" Disable backups
setlocal nobackup

" Disable saving of undo information
setlocal noundofile

" Turn off automatic reformat when text is inserted or deleted
setlocal formatoptions-=a

" Turn off wordwrapper
setlocal nowrap
setlocal textwidth=0
" Don't wrap existing long lines when inserting text.
setlocal formatoptions+=l
setlocal formatoptions-=c
setlocal formatoptions-=t

" Don't show whitespace errors in statusline
silent! call airline#extensions#whitespace#disable()
