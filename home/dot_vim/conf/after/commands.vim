" My commands and command abbreviations

" Note user commands must start with uppercase letter
" http://vimdoc.sourceforge.net/htmldoc/usr_40.html#40.2

" "H" command for current window help {{{ "
" Help that replaces current window instead of opening split
" Uses fact that help will reuse buffer of type help
" Kudos: http://stackoverflow.com/a/26431632/197789
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>
" }}} "H" command for current window help "

" Command abbreviations (cabber and CommandCabbr wrapper) are more flexible,
" http://vimdoc.sourceforge.net/htmldoc/map.html#Abbreviations
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
" Note they take effect anywherein the command (including arguments).
" http://stackoverflow.com/a/3879737/197789

" Use CommandCabbr on itself to define a simpler abbreviation
CommandCabbr ccab CommandCabbr

" Clean up whitespace in file
CommandCabbr clean call<space>WhitespaceClean()

" Close all folds with ':fold'
CommandCabbr fold norm<space>zM

" Re-indent, whole file or selected area
" Kudos: http://vim.wikia.com/wiki/Fix_indentation
CommandCabbr indent call<space>Preserve(':normal<space>gg=G')
" ALternative to above is use '==' to re-indent current line or selection,
" or '<n>==' (e.g. '5==') to re-indent <n> lines

" Turn off paste mode (resume indentation)
CommandCabbr nopaste set<space>nopaste

" Replace tabs with spaces
CommandCabbr notabs set<space>expandtab

" Allow for quick turning on and off soft wrapping of long lines
CommandCabbr nowrap setlocal<space>nowrap!

" Restore ':p' for previous buffer
CommandCabbr p prev

" Turn off indentation for pasting
" Kudos: http://stackoverflow.com/a/2514520/197789
CommandCabbr paste set<space>paste

" Don't replace tabs with spaces
CommandCabbr tabs set<space>noexpandtab

" Open all folds with ':unfold'
CommandCabbr unfold norm<space>zR

" Convert unicode to standard character equivalents
CommandCabbr uniclean call<space>UnicodeClean()

CommandCabbr vimrc call<space>ReloadVIMRC()

" Wrap the current paragraph
CommandCabbr wrap call<space>Preserve(':normal<space>gq}')

" Wrap the whole document
CommandCabbr wrapall call<space>Preserve(':normal<space>gqG')

" Redirect output of command to buffer
" Uses 'Redir' from ../../plugin/Redir.vim
CommandCabbr > Redir
