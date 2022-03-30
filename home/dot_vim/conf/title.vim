" Set window title based on current buffer
" Kudos:
" http://vim.wikia.com/wiki/Automatically_set_screen_title

" Turn on setting the title.
set title

" Set title
" My tmux configuration picks this up and uses it as the pane title.
" Values:
"   %F   Full pathname
"   %M   Modified flag
" The concatenation of the colon is a hack to prevent vim from
" interpreting the string as a modeline. Need to use let to do
" string catenation.
let &titlestring="vim" . ":%F%(\ %M%)"

" Use 99% of available width for title
let &titlelen=99
