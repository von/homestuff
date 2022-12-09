#!/bin/zsh
#
# Set up vi configuration

# Note that if vi crashes with a "Caught deadly signal ABRT" error
# rebuild YouCompleteMe per:
# https://github.com/Valloric/YouCompleteMe/issues/8#issuecomment-13173076

# The vi with MaxOSX is very old, so inistall from homebrew:
#   'brew install macvim' or 'bew install vim'

unfunction vi >& /dev/null  # So we can find actual executable
unalias vim >& /dev/null  # So we can find actual executable

#
# Find preferred neovim, or fall back to vim, then vi
# For test, kudos: http://www.zsh.org/mla/users/2011/msg00070.html
if (( $+commands[nvim] )) ; then
  VI_PATH=$(whence -c nvim)
elif (( $+commands[vim] )) ; then
  VI_PATH=$(whence -c vim)
else
  VI_PATH=$(whence -c vi)
fi

export EDITOR="${VI_PATH}"

vi() {
  # Disable flow control (C-s to freeze output) so we can use C-s in vim
  # http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
  stty stop '' -ixoff

  local _vim_options="${VIM_OPTIONS}"
  # Only autoload session if we have no arguments
  if test -n "${VIM_SESSION}" -a -z "${_vim_options}" -a "$#" -eq 0 ; then
    echo "Starting vi with session ${VIM_SESSION}"
    _vim_options="-c 'call SInit(\"${VIM_SESSION}\")'"
  fi

  # The '=' expands VI_PATH to allow for an argument
  # VIM_OPTIONS lets me set per-shell options
  # The (Q) and (z) carefully control quoting to allow vim commands
  command ${=VI_PATH} ${(Q)${(z)_vim_options}} ${@}
}

alias vim=vi

# Start vi with a session from my sessions directory
# TODO: Create a new session if given one doesn't exist?
export VI_SESSION_PATH=$HOME/.vim-local/sessions/

vis() {
  _args=""
  test -z "$1" && { echo "Usage: $0 {session name}" 1>&2 ; return 1 ; }
  _session_file="$VI_SESSION_PATH/$1"
  test -e "$_session_file" || { echo "No such session: $_session_file" 1>&2 ; return 1 ;}
  ${VI_PATH} -S "${_session_file}"
}

# zsh completion code for vis()
function _completevis {
  reply=($(\ls $VI_SESSION_PATH))
}

compctl -K _completevis vis

# Open vi with scratch buffer
scratch() {
  # Execute vi, preventing loading of session
  env VIM_OPTIONS="" VIM_SESSION="" \
    ${VI_PATH} -c 'let g:startify_disable_at_vimenter = 1' -c ":Scratch"
}

alias s=scratch

# Run a vi command
# e.g. vi_cmd echo \"hello world\"
# Kudos: http://vim.wikia.com/wiki/Find_VIMRUNTIME_in_a_bash_script
vi_cmd() {
  local cmd=${@}
  if test -z "${cmd}" ; then
    echo "Missing command."
    return 1
  fi
  local wrapped_cmd="exe \"set t_cm=\<C-M>\"|${cmd}|quit"
  ${VI_PATH} -e -T dumb --cmd "${wrapped_cmd}" 2>&1 | tr -d '\015'
}

# Find VIMRUNTIME
# Kudos: http://vim.wikia.com/wiki/Find_VIMRUNTIME_in_a_bash_script
# The cd /tmp avoids an error if we are in a non-writable directory.
VIMRUNTIME=$(vi_cmd echo \$VIMRUNTIME)
