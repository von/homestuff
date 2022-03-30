" Allow for lower-case user-defined commands via command abbreviation
" From http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
"
" Note: spaces in expansion need to be escaped with a backslash or <space>
" Note: use single quotes instead of double quotes in expansion

function! CommandCabbr(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
