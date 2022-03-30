" Turn on spell checking
setlocal spell

" Turn on wordwrap
setlocal textwidth=79

" Color column 80
setlocal colorcolumn=80

" Break at characters in 'breakat' (word boundaries)
set linebreak

" Wrap current paragraph
:map <leader>mw gqip

" Turn on automatic reformating with <leader>ma
:nmap <leader>ma :set formatoptions+=a<cr>

" Turn off automatic reformating with <leader>mA
:nmap <leader>mA :set formatoptions-=a<cr>
