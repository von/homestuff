"tmux related configuration
if !empty($TMUX)

" The following are the starting and stopping escape sequences tmux expects
" for setting the pane title.
set t_ts=]2;
set t_fs=\\

" Strikethrough escape codes
set t_Ts=[9m
set t_Te=[0m

" Enable true colour, since vim can't detect it within tmux.
" Requires termguicolors to be set.
" Kudos: https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

endif " TMUX

" TmuxPopupGitroot
"
" Create a tmux popup running a session in the gitroot of the current
" buffer. Intend is to allow me to do command-line git stuff easily
" while not having to jump away from my vim window.
"
" For a fuller interface to tmux, see:
" https://github.com/preservim/vimux
"
" The session name will be "popup-" appended by the basename of the
" gitroot director. This prefix is meaningful as I use it in my tmux
" configuation to detect that I am in a popup. The session will be
" attached to if it already exists, otherwise it will be created.
"
" Arguments:
"   * None
"
" Returns:
"   * Nothing

function! TmuxPopupGitroot()
  if !has_key(environ(), 'TMUX')
    echom "Not inside tmux session."
  endif

  let gitroot = system("git rev-parse --show-toplevel")
  if v:shell_error
    echom "Failed to get gitroot"
    return
  endif
  " Remove trailing newline
  let gitroot = substitute(gitroot, '\n$', '', '')

  " Options to popup
  " Exit when complete, if successful
  let popup_opts = "-E -E"

  " Full-sized popup window
  let popup_opts .=" -xP -yP -w100% -h100%"

  " "popup-" prefix is meaningful in that it is what my tmuxp-popup
  " script looks for to detect it is running in a popup and hence
  " causes it to close that popup instead of running another one.
  let session_suffix = fnamemodify(gitroot, ":t")
  let session_name = "popup-" . session_suffix

  " Options to new-session
  " Attach to session if it already exists
  let session_opts = "-A"
  " Set session name
  let session_opts .= " -s " . session_name
  " Set starting directory to gitroot
  let session_opts .= " -c \"" . gitroot ."\""

  let cmd = "tmux new-session " . session_opts
  let output = system("tmux popup " . popup_opts . " \"" . cmd . "\"")
endfunction
