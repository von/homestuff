" Configuration related to colors
" For list of colors see $VIMRUNTIME/rgb.txt
" To see all colors, run the following:
" :runtime syntax/colortest.vim
" For colors by 0-256 number, see:
" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim

" Useful tools:
" On the Mac, 'Digital Color Meter' (Display Native Values)

" Syntax highlighting
" This causes the loading of highlights, so do it before
" we define our highlights
syntax on

" Control use of gui colors (disabled by default)
" Causes use of guifg and guibf, which can use #rrggbb for colors
" Note that gui uses 'cterm' for attributes.
" For RGB values for 256 colorset, see https://jonasjacek.github.io/colors/
" Note for tmux, see tmux.vim
set termguicolors

" ../colors/von.vim
colorscheme von
