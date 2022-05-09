" vimrc (use double quotes for comments)
" Kudos: http://vim.wikia.com/wiki/Example_vimrc
"
" Loads conf/*.vim and then load Bundles
"
" Also see the ftplugins/ directory for filetype-specific stuff:
" http://vim.wikia.com/wiki/keep_your_vimrc_file_clean
"
" And plugins/ for other automatically loaded configuration
" These are loaded after this file.
" http://vimdoc.sourceforge.net/htmldoc/starting.html#initialization
"
" after/plugin/LoadAfterConf.vim will load conf/after/*.vim after plugins/
"
" Note that MacVim will return true for has("gui_macvim") if it is running as
" either a GUI or on the commandline. Use has("gui_running") to distinguish
" between those two cases.
"
"----------------------------------------------------------------------
" Set up ~/.vim-local {{{ "
" Where we store all our local state that is not in git

let g:vimlocal=expand('~/.vim-local')

" Allow use of autoload in vimlocal. Needed for vim-plug in ./bundles.vim
execute 'set rtp+=' . g:vimlocal

" Only on startup
if has('vim_starting')
  " Keep this in .vimrc as stuff in conf/ and .bundles.vim relies on it
  execute 'silent !mkdir -p ' . g:vimlocal
endif

" }}} Set up ~/.vim-local "
"----------------------------------------------------------------------
" load conf/*.vim {{{ "

" Use 'source' instead of 'runtime' as the latter loads all matching files
" in 'runtimepath'
" Don't use conf/**/*.vim here as we don't want to load conf/after/*.vim
" yet.
for f in split(glob('~/.vim/conf/*.vim'), '\n')
  exe 'source' f
endfor

" Note that after/plugin/LoadAfterConf.vim will load conf/after/*.vim
" after plugin/*.vim

" }}} load conf/*.vim
"----------------------------------------------------------------------
" Load Bundles {{{ "

" Do this after conf/*.vim but before conf/after/*.vim since some
" configuration needs to be run before and some after.
source ~/.vim/bundles.vim

" }}} Load Bundles "
"----------------------------------------------------------------------
" Load man support {{{ "
" Enable the :Man <topic> command
" Use 'runtime!' to load both vim version and my version
" Kudos: http://vim.wikia.com/wiki/View_man_pages_in_Vim
runtime! ftplugin/man.vim
" }}} Load man support "
