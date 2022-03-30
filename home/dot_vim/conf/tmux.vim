"tmux related configuration
if !empty($TMUX)

" The following are the starting and stopping escape sequences tmux expects
" for setting the pane title.
set t_ts=]2;
set t_fs=\\

" Strikethrough escape codes
set t_Ts=[9m
set t_Te=[0m

" Enable true colour, since vim can't detect it within tmux.
" Requires termguicolors to be set.
" Kudos: https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

endif " TMUX
