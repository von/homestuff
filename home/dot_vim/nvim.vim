" neovim configuration file (~/.config/nvim/init.vim)
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Disable Python2
let g:loaded_python_provider = 0

source ~/.vim/vimrc

" Neovim-specific configuration

" Show results of commands incrementally in a split window
" kudos: https://blog.kdheepak.com/three-built-in-neovim-features.html
set inccommand=split

" Neovim doesn't seem to size itself right when I fire it up
" when starting tmux and then neovim quicky. This hack
" causes it to resize itself after starting.
" (This may be true for vim as well.)
" Kudos: https://github.com/neovim/neovim/issues/11330#issuecomment-723667383
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
