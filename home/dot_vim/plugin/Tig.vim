" Tig
" Run tig from within VIM
" XXX: As of tig 2.4.1, if we are not in a git repo, this suspends vim
"      and drops us to shell. See https://github.com/jonas/tig/issues/906

function! Tig()
  if has ('nvim')
    :term tig status
  elseif has('terminal')
    " Use Vim8 terminal with full-width split at bottom
    " XXX The colors aren't right
    :bot split
    :term ++close ++curwin tig status"
  else
    " Pre-Vim8
    "   silent turns off request for enter when tig is done, that requires
    "   refresh supplied by redraw.
    "   Call to GitGutter refreshes its symbols.
    " XXX: The GitGutter call here doesn't seem to be working
    silent !tig status
    GitGutter
    redraw!
  endif
endfunction
