" Set up for password-store temporary files

" Don't save anything
setlocal noswapfile
setlocal noundofile

" Don't do parentheses matching
setlocal noshowmatch
NoMatchParen

" Turn off spell checking
setlocal nospell

" And turn off wordwrap
call WrapOff()

" Conceal the first line with an asterisk
" This works with ../syntax/pass.vim
set conceallevel=1

 " Create the second line if it does not already exist and jump to it
if line('$') == 1 | $put _ | endif
2
