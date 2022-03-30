" Redirect vim command to a buffer
" Kudos: https://vi.stackexchange.com/a/8379/2881
"
" Usage: Redir <cmd>
"   Creates a new buffer with command output.
"
command! -nargs=+ -complete=command Redir let s:reg = @@ | redir @"> | silent execute <q-args> | redir END | new | pu | 1,2d_ | let @@ = s:reg
