" Configuration for :terminal buffers

augroup TerminalOptions
  autocmd!
  " Disable line numbers as hey clutter normal mode
  if has("nvim")
    autocmd TermOpen * if &buftype == 'terminal' | setlocal nonumber | endif
  else
    autocmd TerminalOpen * if &buftype == 'terminal' | setlocal nonumber | endif
  endif
augroup END
