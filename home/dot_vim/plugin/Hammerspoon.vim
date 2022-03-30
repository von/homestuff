" Functions for interacting with Hammerspoon
" Assumes Hammerspoon cli (hs) is installed.
" See: http://www.hammerspoon.org/docs/hs.ipc.html

" Reload my Hammerspoon configuration
function! HammerspoonReload()
  AsyncRun hs -c 'hs.reload()'
  echo "Reloading Hammerspoon configuration"
endfunction

" Have Hammerspoon source current file
function! HammerspoonSourceCurrentFile()
  call HammerspoonSourceFile(expand('%:p'))
endfunction

" Have Hammerspoon source given file
function! HammerspoonSourceFile(path)
  exec ":AsyncRun hs " . a:path
  echo "Hammerspoon sourcing " . a:path
endfunction
