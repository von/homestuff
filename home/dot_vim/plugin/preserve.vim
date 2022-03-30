" Preserve(): save last search, and cursor position.
" Not command must be an ex command (e.g., ":norm gg=G")
" Kudos: https://github.com/nelstrom/dotfiles/blob/master/vimrc
function! Preserve(command)
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
