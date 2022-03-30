" Configuration for Unicode/Non-ascii
" Kudos: http://stackoverflow.com/a/16988346

" Replace unicode characters with ascii equivalents
" Kudos: http://www.cl.cam.ac.uk/~mgk25/ucs/quotes.html
" Kudos: http://stackoverflow.com/a/2801132/197789
function! UnicodeClean()
  " Left single quote(‘) to apostrophe(')
  call Preserve(":%s/\\%u2018/'/ge")
  " Right single quote(’) to apostrophe(')
  call Preserve(":%s/\\%u2019/'/ge")
  " Left double quote(“) to neutral quote(")
  call Preserve(":%s/\\%u201C/\"/ge")
  " Right double quote(”) to neutral quote(")
  call Preserve(":%s/\\%u201D/\"/ge")
  " Some sort of funky space
  call Preserve(":%s/ / /ge")
endfunction

" Highlight non-ascii {{{
" Kudos https://stackoverflow.com/a/27690622/197789

let g:is_non_ascii_on = 0

function! HighlightNonAsciiOff()
  echom "Setting non-ascii highlight off"
  highlight nonascii none
  let g:is_non_ascii_on=0
endfunction

function! HighlightNonAsciiOn()
  syntax match nonascii "[^\x00-\x7F]" containedin=cComment,vimLineComment,pythonComment
  echom "Setting non-ascii highlight on"
  highlight nonascii cterm=underline ctermfg=green ctermbg=none term=underline
  let g:is_non_ascii_on=1
endfunction

function! ToggleHighlightNonascii()
  if g:is_non_ascii_on == 1
    call HighlightNonAsciiOff()
  else
    call HighlightNonAsciiOn()
  endif
endfunction
" }}}
