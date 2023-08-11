"
" See also after/commands.vim
"
" To see key mappings and their source, use ':verbose map'
" Kudos: http://stackoverflow.com/a/7644189/197789
"
" To see default vim key bindings, use ':help index'
" Kudos: http://stackoverflow.com/a/2484137/197789

" Note that vim-tmux-navigator uses the following keybindings:
" C-h, C-l, C-j, C-k, C-\

" Disable automatic keybinds of bundles {{{ "

" Buffergator
let g:buffergator_suppress_keymaps=1

" }}} Disable automatic keybinds of bundles "

" Multi-character bindings:
"  <leader> (space)   Used for navigation and UI manipulation
"  <comma>            Used to change buffer contents
"  <backslash>        Used to set options

" Leader bindings {{{ "
" Navigation and UI manipulation.

" Use space as leader
" Kudos: http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
let mapleader = "\<Space>"

" Clear highlighted search results
:map <leader><leader> :noh<cr>

" Open menu of tabs
:map <leader><tab> :Unite tab<cr>

" Switch to previous buffer
:map <leader>b :e #<cr>

" Open buffer
:map <leader>B :Buffers<cr>

" Toggle fold open/close
:map <leader>f za

" Open all folds with search results
" Kudos: https://stackoverflow.com/a/18805662/197789
:map <leader>F :g//foldopen<CR>

" <leader>g for git interactions
" Following are a mix of Fugitive, GitGutter, and Fzf
" Use ':tab <cmd>' to open some commands in new tab
" kudos: https://github.com/tpope/vim-fugitive/issues/727
nnoremap <leader>ga :tab Git commit --amend<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gc :tab Git commit<cr>
nnoremap <leader>gd :GitGutterPreviewHunk<cr>
nnoremap <leader>gD :Git diff<cr>
nnoremap <leader>gf :GitGutterFold<cr>
nnoremap <leader>gl :BCommits<cr>
nnoremap <leader>gp :Git pull<cr>
nnoremap <leader>gP :Git push<cr>
nnoremap <leader>gs :call GitAddHunkOrFile()<cr>
nnoremap <leader>gS :tab G<cr>
nnoremap <leader>gz :GitGutterFold<cr>
nnoremap <leader>g! :GitGutterUndoHunk<cr>

" <leader>G is grep via unite
nnoremap <silent> <leader>G :UniteWithProjectDir grep:.<cr>

" <leader>h is used by git-gutter

" Show highlight group under cursor with <leader>H
" SynStack() from colors.vim
:map <silent> <leader>H :call SynStack()<CR>

" <leader>m is reserved for mode-specific bindings

" vim_markdown_preview: Replace default C-p
let vim_markdown_preview_hotkey='<leader>mP'

" <leader>M toggle Quickmenu
:map <leader>M :call quickmenu#toggle(0)<cr>

if !has("gui_running")
  " Open file finder

  " Run GFiles if we are in a git repo, otherview Files
  function! FilesOrGFiles()
    let discard = system("git status")
    if v:shell_error == 0
      :GFiles
    else
      :Files
    endif
  endfunction

  :map <leader>o :call FilesOrGFiles()<CR>
  :map <leader>O :Vifm<CR>
endif

" Close buffer without exiting (uses moll/vim-bbye)
:map <leader>q :Bdelete<cr>

" Quit all buffers with 'Q'
:map <leader>Q :qa<cr>

" Redraw with 'R'
:map <leader>R :GitGutter<cr>:redraw!<cr>

" Open a scratch buffer with 's'
:map <leader>s :call ToggleScratch()<CR>

" Toggle session menu
:map <leader>S :call SessionMenu()<CR>

" Run tig to do my git stuff
"   silent turns off request for enter when tig is done, that requires
"   refresh supplied by redraw.
"   Call to GitGutter refreshes its symbols.
" XXX: The GitGutter call here doesn't seem to be working
" XXX: As of tig 2.4.1, if we are not in a git repo, this suspends vim
"      and drops us to shell. See https://github.com/jonas/tig/issues/906
:map <leader>t :call Tig()<cr>

" Open tagbar, jump to it, and close when done
:map <leader>T :TagbarOpenAutoClose<cr>

if !has("gui_running")
  :map <leader>v :silent !vifm<cr>:redraw!<cr>
endif

" Select the region we just pasted
" Kudos: https://stackoverflow.com/a/4313335/197789
:map <leader>V `[v`]

" Save with <leader>w
:map <leader>w :w<cr>
" In visual mode, don't save partial file and restore visual selection.
:vmap <leader>w :<C-U>w<cr>gv

" Open a vimwiki
:map <leader>W :VimwikiUISelect<cr>

" Close all folds with <leader>z
:map <leader>z zM

" Open all folds with <leader>Z
:map <leader>Z zR

" Window manipulation {{{ "
"
" Kudos: http://codeincomplete.com/posts/2011/3/4/my_vimrc_file/

" Don't open file explorer with splits since I'm more likely to be doing a
" split to get two views on the current file.

" Split vertically with '|'
map <leader><Bar>   :vsplit<cr>

" Split horizontally with '-'
map <leader>-       :split<cr>

" Window resizing
nnoremap <silent> <Leader><Up> <C-W>-
nnoremap <silent> <Leader><Down> <C-W>+
nnoremap <silent> <Leader><Right> <C-W>>
nnoremap <silent> <Leader><Left> <C-W><
" Balance windows
nnoremap <silent> <Leader>= <C-W>=

" Toggle Maximizing current window (uses vim-maximizer)
" Note that mapping to '<C-W>o' here doesn't work for some reason.
nnoremap <silent> <Leader><CR> :MaximizerToggle<CR>

" Make current window 80 columns wide (including lines numbers)
" Kudos: http://stackoverflow.com/a/16110704
" Note <gt> doesn't seem to work here, so use '>'
nnoremap <silent> <Leader>> 83<C-W><Bar>

" }}} Window manipulation
" }}} Leader bindings

" Comma-bindings {{{ "
" Used to change buffer contents

" Comment/uncomment current line or, if active, region
:map ,c :Commentary<cr>

" Uncomment current and adjacent lines
:map ,C gcu

" Re-wrap paragraph
:map ,f {gq}

" Re-wrap whole file
:map ,F gqG

" Paste from system pastebuffer
:map ,p "+p

" Clean up whitespace
:map ,S :clean<cr>

:map ,u :GundoToggle<cr>

" Yank line to system pastebuffer
" Note yy yanks line including carriage return which will screw up
" passwords! 'g_' is like '$' but without newline.
" Kudos: http://stackoverflow.com/a/20165747/197789
:map ,y ^vg_"+y
" In visual mode, yank block
:vnoremap ,y "+y

" Yank file to system pastebuffer
:map ,Y :%y+<cr>

" }}} Comma-bindings "

" Backslash bindings {{{ "
" Used to set options

" Turn on soft wrap
:map \W :call WrapSoft()<cr>

" Turn on hard wrap
:map \Wh :call WrapHard()<cr>

" Turn off word wrapping
:map \Wo :call WrapOff()<cr>

" Turn on soft wrap
:map \Ws :call WrapSoft()<cr>

" }}} Backslash bindings "

" Control characters {{{ "

" Map C-s to back-screen because C-b is used by tmux
" Note this requires terminal to ignore C-s
" http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
:map <C-s> <C-B>

" Kudos: https://stackoverflow.com/a/563992/197789
" C-] jumps to function under cursor via ctags
" Ctrl+T - Jump back from the definition.
" Ctrl+W Ctrl+] - Open the definition in a horizontal split

" Control characters }}}

" {{{ Carriage return
" Type 12<Enter> to go to line 12
" Hit Enter to go to end of file.
" Kudos: http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
nnoremap <CR> G

" Let me use <CR> as normal in quickfix to jump to things
" Kudos: http://stackoverflow.com/a/11983449/197789
augroup quickfixcr
  autocmd!
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
augroup END
" See also ../ftplugin/qf.vim

" }}} Carriage return

" Plus and minus open and close all folds {{{ "
nnoremap - zM
nnoremap + zR
" }}} Plus and minus open and close folds "

" <,>,= maintain visual selection {{{ "
" Kudos: http://stackoverflow.com/a/3702781/197789
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv
" }}}

" Hit Backspace to go to beginning of file.
" Kudos: http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
nnoremap <BS> gg

" I don't want to go into Ex mode by accident
nmap Q <nop>

" Remap 0 and $ to for SoftWrap {{{
" Go to first non-whitepace character on line, then first column of line or
" paragraph. Seems to work well for soft-wrapped or unwrapped.
nnoremap <silent> 0 :call ToggleMovement('g^', '0')<CR>
" End of wrapped line, then end of paragraph
nnoremap <silent> $ :call ToggleMovement('g$', '$')<CR>
" }}} Remap 0 and $ to for SoftWrap

" Remap Up/Down to work with soft wrap nicely {{{
noremap  <Up>   gk
noremap  <Down> gj
noremap  k gk
noremap  j gj
" }}} Remap Up/Down to work with soft wrap nicely

" Popup keybindings {{{
" See :help popupmenu-keys

" <Tab> completes deoplete popup if Open, otherwise acts normally
inoremap <expr> <Tab> pumvisible() ? "<CR>" : "<Tab>"

" Left cancels completion
inoremap <expr> <Left> pumvisible() ? "\<C-E>" : "\<Left>"

"
" Command mode completions

" Up and Down work as expected
cnoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"

" Right completes
cnoremap <expr> <Right> pumvisible() ? "\<C-Y>" : "\<Right>"

" Left cancels completion
cnoremap <expr> <Left> pumvisible() ? "\<C-E>" : "\<Left>"

" }}} Popup keybindings

" Bindings for Ultisnips {{{
" Uses <S-Tab> and <C-l>. See ultisnips.vim
" }}} Bindings for Ultisnips

" Normal-mode bindings {{{ "

" C-c in normal mode closes quickfix
nmap <C-C> :cclose<cr>

" }}} Normal-mode binginds "

" Insert-mode bindings {{{

" Make Control-C behave like Escape for exiting insert mode.
" Normally C-c does not check for abbreviations or trigger the |InsertLeave|
" autocommand event. (See :help i_CTRL-C)
inoremap <C-C> <Esc>
" }}}

" Command-mode bindings {{{

" Allow use of semi-colon to enter command mode
" Kudos: http://blog.unixphilosopher.com/2015/02/five-weird-vim-tricks.html
nnoremap ; :

" Run a command with '!'
" Kudos: http://blog.unixphilosopher.com/2015/02/five-weird-vim-tricks.html
nnoremap ! :!

cnoremap <C-K> <C-E><C-U>
cnoremap <C-U> <C-E><C-U>

" }}}

" Visual-mode bindings {{{ "

" Call TwiddleCase on selection
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" Bindings for vim-expand-region
" Kudos: http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" }}} Visual-mode bindings "

" Terminal-Job bindings {{{ "

" <C-W>n: Change to Terminal-Normal mode
"         Documentation says this is the default, but that's not my experience
tmap <C-W>n <C-\><C-N>

" <C-W><C-Z>: Toggle zoom
" XXX a running curses application (e.g. tig) won't resize
tmap <C-W><C-Z> <C-W>:silent call ZoomWin#ZoomWin()<CR>

" }}} Terminal-Job bindings "

" Bracket ([,]) bindings {{{ "

" Bracket-g to jump between GitGutter hunks
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)

" Use vim-qf functions for navigating quickfix
nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)

" Find previous unicode character
nmap [U ?[^\x00-\x7F]<cr>
" Find next unicode character
nmap ]U /[^\x00-\x7F]<cr>

" }}} Bracket ([,]) bindings "

" Map n and N to HLNext() {{{ "
" Find next search match and briefly highlight it.
" The 'zv' opens folds if needed
nnoremap <silent> n   nzv:call HLNext(0.4)<cr>
nnoremap <silent> N   Nzv:call HLNext(0.4)<cr>
" }}} Map n and N to HLNext() "

" T prefix for tab command {{{ "
" Kudos: http://vim.wikia.com/wiki/Alternative_tab_navigation

" Close tab
nnoremap <silent> Tc :tabclose<cr>

" List of tabs
nnoremap <silent> Tl :Unite tab<cr>

" Close tab
nnoremap <silent> Tn :tabnew<cr>

" Last tab
" Kudos: https://superuser.com/a/675119/128341
let g:lasttab = tabpagenr()
augroup lasttab
  autocmd!
  autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END
nnoremap <silent> TT :exe "tabn " . g:lasttab<cr>

" }}} T prefix for tab command "

" Use Tab/S-Tab to jump forward/backward in search hits {{{ "
" Kudos: http://stackoverflow.com/a/40193754/197789
" The 'zv' opens folds if needed

" needed for mapping <Tab> in command-line mode
set wildcharm=<C-z>

cnoremap <expr> <Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>zv/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>zv?<C-r>/" : "<S-Tab>"
" }}} Use Tab/S-Tab to jump forward/backward in search hits "

" Fix broken gx {{{
" See https://github.com/vim/vim/issues/4738
" Kudos: https://github.com/vim/vim/issues/4738#issuecomment-521506447
nnoremap <silent> gx :!open <cWORD><CR>:redraw!<CR>

" }}} Fix broken gx

" 'yf' to copy file/url {{{ "
" Kudos: https://vi.stackexchange.com/a/27572/2881
" Kudos: https://vi.stackexchange.com/a/24840/2881
nnoremap <silent> yf :let @* = expand('<cfile>') \| :echom 'Copied'<CR>
" }}} 'yf' to copy file/url "

" Shift-arrows for when not in tmux {{{ "
" This includes running in MacVim
if empty($TMUX)
  noremap <S-left> <C-w><C-h>
  noremap <S-right> <C-w><C-l>
  noremap <S-up> <C-w><C-k>
  noremap <S-down> <C-w><C-j>
endif

" }}} Shift-arrows for when not in tmux "

" Timeouts {{{ "

" Timeout on mappings and key codes
set timeout ttimeout

" Mapping delay
set timeoutlen=500

" Key code delay
set ttimeoutlen=500

" }}} Timeouts "
