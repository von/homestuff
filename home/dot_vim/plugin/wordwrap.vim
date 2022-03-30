" Word wrap functions

" WrapSoft() {{{ "

" Turn on soft (no insertion of characters) wrapping Kudos:
" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks Kudos:
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
function! WrapSoft()
  " wrap tells Vim to word wrap visually (as opposed to changing the text
  " in the buffer)
  setlocal wrap
  " Disable wrapping and don't wrap when getting close to right margin.
  setlocal textwidth=0
  setlocal wrapmargin=0
  " If you want to keep your existing 'textwidth' settings for most lines in
  " your file, but not have Vim automatically reformat when typing on existing
  " lines, you can do this with:
  setlocal formatoptions-=t
  " Don't wrap lines that are already longer than textwidth before inserting
  " more text.
  setlocal formatoptions+=l
  " Turn off virtualedit, i.e. allowing cursor positioning where there is no
  " actual character (e.g. in tabs, past end of line)
  set virtualedit=
  " Display as much of last line as possible.
  setlocal display+=lastline
endfunction

" }}} WrapSoft() "

" WrapHard() {{{ "

" Turn on hard (insert carriage returns) wrapping
function! WrapHard()
  " Turn off soft wrap
  setlocal nowrap
  " That will automatically wrap text as close to 79 characters as white space
  " allows without exceeding the 79 character limit. This option wraps at word
  " boundaries.
  setlocal formatoptions+=t
  setlocal textwidth=79
  " Wrap lines that are longer than textwidth before lengthening them.
  setlocal formatoptions-=l
endfunction

" }}} WrapHard() "

" WrapOff() {{{ "

" Turn off any wrapping
function! WrapOff()
  setlocal nowrap
  " Don't hard wrap text
  setlocal textwidth=0
  " Don't wrap existing long lines when inserting text.
  setlocal formatoptions+=l
  setlocal formatoptions-=c
  setlocal formatoptions-=t
endfunction
" }}} WrapOff() "
