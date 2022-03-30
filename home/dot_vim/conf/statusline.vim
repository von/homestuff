" statusline configuration (via airline)
" Source this and then use AirlineRefresh to reload

" Always display the status line, even if only one window is displayed
set laststatus=2

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Enable fugitive support with statline
let g:statline_fugitive = 1

" I'm seeing errors with the unite extension so disable it
let g:airline#extensions#unite#enabled = 0

" Airline Configuration {{{ "

" Show whitespace errors
let g:airline#extensions#whitespace#enabled = 1

" Set airline theme
" Kudos: http://choorucode.com/2015/03/18/how-to-use-themes-in-airline/
let g:airline_theme='vonairlinetheme'


" {{{ Use unicode symbols in airline
"
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.whitespace = 'Ξ'
"}}}

" {{{ tabline configuration

" Show tabline once we have 2 or more tabs
let g:airline#extensions#tabline#tab_min_count = 2

" Use taboo to show tabs
" This means most of the airline configuration is ignored
let g:airline#extensions#taboo#enabled = 1

" Turn on enhanced tabline
let g:airline#extensions#tabline#enabled = 1

" Let taboo show the tab numbers
let g:airline#extensions#tabline#show_tab_nr = 0

" Tab label format: <number>:<name><modified>
let g:taboo_tab_format = "[%N] %f%m"
let g:taboo_renamed_tab_format = "[%N] %l%m"

" The `unique_tail_improved` - another algorithm, that will smartly uniquify
" buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Show tabs instead of buffers
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_buffers = 0

" {{{ Clean up tabline
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
" }}} Clean up tabline

" {{{ Add keybindings to jump to tabs
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt
" }}} Index buffers in tabline and add keybindings
" }}} tabline configuration

if !has('vim_starting')
  " If reloading configuration, refresh Airline
  :AirlineRefresh
endif

" }}} Airline Configuration "
