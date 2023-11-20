" Load bundles
"
" VimPlug setup {{{
"
" Use ~/.vim-bundle to keep bundles out of git repo
" This is needed in part because YCM used submodules
let g:pluginInstallDir = expand('~/.vim-bundle')

" If our pluginInstallDir doesn't exist, bootstrap
if !isdirectory(g:pluginInstallDir)
  execute 'silent! mkdir -p ' . g:pluginInstallDir
endif

" Keep plug.vim in vimlocal to keep it from cluttering git repo
" and allow automatic upgrading via PlugUpgrade
if empty(glob(g:vimlocal . '/autoload/plug.vim'))
  execute 'silent !curl -fLo ' . g:vimlocal . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin(g:pluginInstallDir)

" }}} VimPlug setup
"----------------------------------------------------------------------
" Load Bundles {{{
"
" Note that bundles apparently need to be in vimrc (as opposed to
" in a plugin).

" Show git changes on left
Plug 'airblade/vim-gitgutter'

" Handle chezmoi templates correctly
Plug 'alker0/chezmoi.vim'

" Fancy statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Rename current buffer with ':rename <name>'
Plug 'danro/rename.vim'

" C-p: Open files with fuzzy matching
Plug 'ctrlpvim/ctrlp.vim'

if !has("gui_running")
  " Allow one-keystroke navigation between vi panes and tmux panes
  " Use Control-<arrow keys> to switch between panes/vim windows
  " My tmux.conf maps S-<arrow keys> to C-<arrow keys> in vim
  Plug 'christoomey/vim-tmux-navigator'
endif

" Allow me to rename tabs
Plug 'gcmt/taboo.vim'

" Allow for easy rendering of markdown
Plug 'JamshedVesuna/vim-markdown-preview'

" FZF plugin
" Basic fzf integration and ensure binary is found
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Rich set of fzf commands: Files, Ag, etc
" See https://github.com/junegunn/fzf.vim or 'help fzf-vim-commands'
Plug 'junegunn/fzf.vim'

" Allows definiton of arbitrary objects (prereusite of following)
Plug 'kana/vim-textobj-user'
" vim-textobj-entire adds text object of 'ae' for entire buffer
" ('ie' excludes leading and trailing whitespace)
Plug 'kana/vim-textobj-entire'
" Adds 'al' for entire line and 'il' without leading and trailing whitespace
Plug 'kana/vim-textobj-line'

" Basically a Python IDE
" Note this resets the filetypedetect augroup so some other bundles need
" to be after this plugin, namely securemodelines
Plug 'klen/python-mode'

" Automatically create tags files
" https://github.com/ludovicchabant/vim-gutentags
Plug 'ludovicchabant/vim-gutentags'

" https://github.com/preservim/tagbar
" Formerly 'majutsushi/tagbar'
Plug 'preservim/tagbar'

" Allow be to run commands in a tmux popup
" https://github.com/preservim/vimu,
Plug 'preservim/vimux'

" For BDelete
Plug 'moll/vim-bbye'

" Markdown file folding and commands
Plug 'plasticboy/vim-markdown'

" Quickfix commands
Plug 'romainl/vim-qf'

" If we are running on neovim use deoplete, otherwise YouCompleteMe
" The latter has performance problems with large files, but the
" former only works on neovim
if has('nvim')
  " Deoplete: https://github.com/Shougo/deoplete.nvim
  " If deoplete isn't working, run ':UpdateRemotePlugins' and restart vim
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
else
  " https://github.com/ycm-core/YouCompleteMe
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
endif


" Interative command execution (needed for unite)
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" For grep via <leader>g
Plug 'Shougo/unite.vim'

" Let me associate buffers with tabs
Plug 'Shougo/tabpagebuffer.vim'

" Allow snippet expansion with <tab>
Plug 'SirVer/ultisnips'
" Snippets for ultisnips
Plug 'honza/vim-snippets'

" Let me view all my undo information with <leader>u
if has('python3')
  " Work with python3.
  " Kudos: https://bitbucket.org/sjl/gundo.vim/issues/42/about-python3-support
  let g:gundo_prefer_python3 = 1
endif
Plug 'sjl/gundo.vim'

" Let me run async commands in VIM > 8
Plug 'skywind3000/asyncrun.vim'

" Let me pop up a menu of commands
Plug 'skywind3000/quickmenu.vim'

" Allow changing surround quotes with 'cs<current><new>'
Plug 'tpope/vim-surround'

" Allow use of 'v' to expand region, 'V' to shrink
Plug 'terryma/vim-expand-region'

" So Focus autocmds work right. Important for GitGutter
" Note: this requires 'set -g focus-events on' in tmux.conf
Plug 'tmux-plugins/vim-tmux-focus-events'

" Allow for use of {x,y} in abbrevIation and substitutions
" Plus: crc for camelCase, crm for MixedCase, and crs for snake_case
Plug 'tpope/vim-abolish'

" 'gcc' to comment/uncomment line, or gc<motion target>
Plug 'tpope/vim-commentary'

" :GBlame and friends
Plug 'tpope/vim-fugitive'

" readline-like key bindings in insert mode
Plug 'tpope/vim-rsi'

" Start screen for vim
Plug 'mhinz/vim-startify'

" Allow toggling full screen windows
let g:maximizer_set_default_mapping = 0
Plug 'szw/vim-maximizer'

" Better indentation for lua
Plug 'tbastos/vim-lua'

" Key bindings with '[' and ']' prefixes
Plug 'tpope/vim-unimpaired'

if !has("gui_running")
  " Integration with vifm
  " Doesn't work with MacVim GUI
  Plug 'vifm/vifm.vim'
endif

" Highlighting for applescript
Plug 'vim-scripts/applescript.vim'

" Highlighting for BATS
" https://github.com/sstephenson/bats
Plug 'vim-scripts/bats.vim'

" For :Scratch and Sscratch
Plug 'vim-scripts/scratch.vim'

" Wikis in ~/vimwiki by default
" Disable table_mappings as they interfere with tab expansion
let g:vimwiki_key_mappings = { 'table_mappings': 0 }
Plug 'vimwiki/vimwiki'

" Only allow certain things in modelines
" Note this needs to be loaded after python-mode since that seems
" to reset the filetypedetect autogroup which causes ftplugin to
" run after modeline processing.
Plug 'ypcrts/securemodelines'

call plug#end()

" }}} Misc Bundles
