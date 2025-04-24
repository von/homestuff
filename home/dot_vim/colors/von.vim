" My colorscheme based on koehler
" Vim color file

" Special colors:
" 236/#303030 is a Medium grey I use as a background for linenummbers, the
"             current cursor line, and inactive windows.

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "von"

if has("gui_running")
  " We need to explicity set background for MacVim GUI
  hi Normal		  guifg=white  guibg=black

  " GUI-only highlights
  hi Scrollbar	  guifg=darkcyan guibg=cyan
  hi Menu	  guifg=black guibg=cyan
  " + Tooltip
else
  " NONE for background lets tmux highlighting of active pane work correctly
  " Kudos: https://stackoverflow.com/a/37720708/197789
  hi Normal		  guifg=white  guibg=NONE
endif


" Folds {{{ "

" Make folds blue on grey (same as line numbers)
" To look good, the background should match inactive tmux window color.
hi Folded         ctermfg=039 ctermbg=236 guifg=#00afff guibg=#303030

" }}} Folds "
" Startify {{{ "
hi StartifyBracket ctermfg=240 guifg=#FFD3D5
" Filenames
hi StartifyFile    ctermfg=240 guifg=#00FFFF
" Custom footer
hi StartifyFooter  ctermfg=240
" Custom header
hi StartifyHeader  ctermfg=114 guifg=Yellow
" Numbers in brackets
hi StartifyNumber  ctermfg=215 guifg=#FF55FF
" Path up to file
hi StartifyPath    ctermfg=245 guifg=#99FFFF
" Section headings
hi StartifySection ctermfg=240 guifg=Yellow
" Selected entries
hi StartifySelect  ctermfg=240 guifg=Black guibg=#600060
" Slashes in paths
hi StartifySlash   ctermfg=240 guifg=Cyan
" <empty buffer>,<quit>
hi StartifySpecial ctermfg=240 guifg=Cyan
" Environment variables
hi StartifyVar     ctermfg=240 guifg=Yellow
" }}} Startify "
" Comments {{{ "
hi Comment		  term=bold  cterm=italic ctermfg=14  guifg=#00ffff
" Title: <- example of a vimCommentTitle
:hi vimCommentTitle ctermfg=14 cterm=italic guifg=#00aaff
" Not sure what this is
hi link SpecialComment	Special
" }}} Comments "
" TODO/XXX in comments {{{
hi clear VimTodo
hi VimTodo        cterm=underline ctermfg=yellow guifg=Yellow

hi link shTodo          VimTodo
hi link zshTodo         VimTodo
hi link luaTodo         VimTodo
hi link luaCommentTodo  VimTodo
hi link pythonTodo      VimTodo
hi link confTodo        VimTodo
hi link tmuxTodo        VimTodo
hi link perlTodo        VimTodo
hi link javaScriptCommentTodo VimTodo
" }}}
" tmux {{{ "
" Make 'colour236' visible
hi clear tmuxColour236
" }}} tmux "
" Unite {{{ "
hi clear uniteSource__GrepPattern
hi uniteSource__GrepPattern cterm=underline ctermfg=yellow guifg=Yellow
" }}} Unite "
" HTML {{{ "
hi clear htmlItalic
hi htmlItalic     cterm=italic ctermfg=grey guifg=Gray
" }}} Unite "
" vim {{{
hi vimHiCtermError cterm=underline ctermfg=red guifg=Red
hi vimUserAttrbError cterm=underline ctermfg=red guifg=Red
" }}}}
" Constants/strings {{{ "
hi Constant		  term=underline  cterm=bold ctermfg=13 guifg=#0087af

" }}} Constants/strings "
" Special {{{ "

hi Special        term=bold cterm=bold ctermfg=224 guifg=#afd700
" Unprintable characters
hi SpecialKey	  term=bold  cterm=bold  ctermfg=darkred  guifg=#cc0000
hi link SpecialChar		Special

" }}} Special
" Customize tabbar {{{
" http://stackoverflow.com/a/7238163/197789
"
" Active label
hi TabLineSel     guifg=Yellow guibg=DarkBlue gui=bold ctermfg=Yellow ctermbg=DarkBlue cterm=bold,underline
" Inactive labels
hi TabLine        guifg=White guibg=DarkBlue gui=none ctermfg=White ctermbg=DarkBlue cterm=none
" Remainder of tabbar
hi TabLineFill    guifg=White guibg=DarkBlue gui=none ctermfg=White ctermbg=DarkBlue cterm=none

" }}}
" SignColumn {{{
" For git-gutter
" Clear so we use LineNr
hi clear SignColumn
" }}} SignColumn
" ColorColumn {{{

" For colorcolumn on column 80 (Grey matching cursorline)
" Also used for dimmed screens by blueyed/vim-diminactive
hi ColorColumn    ctermbg=236 guibg=#303030

" }}} SignColumn
" Completion Menu {{{
" Kudos: https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
hi Pmenu          ctermbg=White ctermfg=Blue guibg=White guifg=Blue
hi PmenuSel       cterm=reverse gui=reverse
hi PmenuSbar      ctermbg=Grey ctermfg=Grey guibg=Gray guifg=Gray
hi PmenuThumb     ctermbg=Blue ctermfg=Blue guibg=Blue guifg=Blue
" }}} Completion Menu
" Help {{{ "
" Get rid of colored backgrounds
hi helpNote       ctermfg=yellow ctermbg=none guifg=Yellow guibg=NONE
hi helpTodo       ctermfg=green ctermbg=none guifg=Green guibg=NONE
hi helpError      ctermfg=red ctermbg=none cterm=underline guifg=Red guibg=NONE
hi helpHyperTextJump ctermfg=red ctermbg=none cterm=underline guifg=#A0A0FF guibg=NONE
" }}} Help "
" Spell checking {{{ "
" Make misspellings red and underlined instead of red background
" Kudos: http://stackoverflow.com/a/6009026/197789
hi clear SpellBad
hi SpellBad       cterm=underline ctermfg=red guifg=Red
hi clear SpellCap
hi SpellCap       cterm=underline ctermfg=red guifg=Red
hi clear SpellRare
" }}} Spell checking "
" Linenumbers {{{
"
" Line numbers are light blue with dark grey background.
" This also controls the line numbers for pylint errors.
" To look good, this should match inactive tmux window color.
hi LineNr         cterm=None ctermfg=039 ctermbg=236 guifg=#00afff guibg=#303030
" See also CursorLineNr

" }}} Linenumbers
" CursorLine {{{ "
hi CursorLine     cterm=None ctermfg=None ctermbg=236 guibg=#303030

" XXX This doesn't seem to be working
" CursorLineNr as set by plugin/CursorLine.vim
" CursorLineNr for insert mode
hi CursorLineNrInsert  cterm=None ctermfg=black ctermbg=green guifg=Black guibg=Green
hi CursorLineNrNormal  cterm=None ctermfg=None ctermbg=236 guifg=Yellow guibg=#303030
hi CursorLineNrReplace cterm=None ctermfg=black ctermbg=blue guifg=Black guibg=Blue
hi CursorLineNrVirtual cterm=None ctermfg=black ctermbg=red guifg=Black guibg=Red

" Set default (need to clear in order to link)
hi clear CursorLineNr
hi link CursorLineNr CursorLineNrNormal

" }}} CursorLine "
" Shell script {{{ "
" Set to make background clear
hi shDerefWordError guifg=red guibg=NONE
hi shDerefOpError guifg=red guibg=NONE
" }}} Shell script "
" Search results {{{ "
hi Search		  term=reverse  ctermfg=white  ctermbg=red guifg=white  guibg=#A02020
" }}} Search results "
" EndOfBuffer and NonText {{{ "
" Tildes at the end of the buffer.
hi EndOfBuffer	  term=bold  cterm=bold  ctermfg=darkred guifg=#5440A5 gui=bold
" Characters that are used by vim to indicate things
hi NonText		  term=bold  cterm=bold  ctermfg=darkred  gui=bold      guifg=#cc0000
" }}} EndOfBuffer and NonText "
" StatusLine {{{ "
hi StatusLine	  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
hi StatusLineNC   term=reverse	ctermfg=white ctermbg=lightblue guifg=white guibg=blue
" }}} StatusLine "
" Visual mode selected text {{{ "
hi Visual		  ctermbg=242 guibg=#6C6C6C
" }}} Visual mode selected text "
" Concealed text {{{ "
" soft background with yellow text
hi Conceal		  guifg=yellow guibg=#303030
" }}} Concealed text "
" Character under cursor {{{ "
hi Cursor		  guifg=bg	guibg=Green
" }}} Character under cursor "
" Misc {{{ "
hi Directory	  term=bold  cterm=bold  ctermfg=brown  guifg=#cc8000
hi ErrorMsg		  term=standout  cterm=bold  ctermfg=grey  ctermbg=red  guifg=White  guibg=Red

hi MoreMsg		  term=bold  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=SeaGreen
hi ModeMsg		  term=bold  cterm=bold  gui=bold  guifg=White	guibg=Blue
hi Question		  term=standout  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=Green
hi Title		  term=bold  cterm=bold  ctermfg=darkmagenta  gui=bold	guifg=Magenta

hi WarningMsg	  term=standout  cterm=bold  ctermfg=darkred guifg=Red
hi Constant		  term=underline  cterm=bold ctermfg=magenta  guifg=#ffa0a0
hi Identifier	  term=underline   ctermfg=brown  guifg=#40ffff
hi Statement	  term=bold  cterm=bold ctermfg=yellow	gui=bold  guifg=#ffff60
hi PreProc		  term=underline  ctermfg=darkmagenta   guifg=#ff80ff
hi Type			  term=underline  cterm=bold ctermfg=lightgreen  gui=bold  guifg=#60ff60
hi Error		  term=reverse	ctermfg=darkcyan  ctermbg=black  guifg=Red	guibg=Black
hi Todo			  term=standout  ctermfg=black	ctermbg=darkcyan  guifg=Blue  guibg=Yellow
hi MatchParen	  term=reverse  ctermfg=blue guibg=Blue
hi Underlined	  term=underline cterm=bold,underline ctermfg=lightblue guifg=lightblue gui=bold,underline
hi Ignore		  ctermfg=black ctermbg=black guifg=black guibg=black

hi link IncSearch		Visual
hi link String			Constant
hi link Character		Constant
hi link Number			Constant
hi link Boolean			Constant
hi link Float			Number
hi link Function		Identifier
hi link Conditional		Statement
hi link Repeat			Statement
hi link Label			Statement
hi link Operator		Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link Delimiter		Special
hi link Debug			Special
" }}} Misc "
