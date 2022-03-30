" 
" Visually select text then press ~ to convert the text to UPPER CASE,
" then to lower case, then to Title Case. Keep pressing ~ until you get
" the case you want.
"
" Kudos: http://vim.wikia.com/wiki/Switching_case_of_characters

function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
