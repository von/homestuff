# jump.zsh
#
# See ../dot_bin/executable_jumplist.sh

# Variables:
#  $JUMP_ROOT - start of find for directories if set, otherwise $HOME

function jump() {
  local selected=""
  if test -n "${1}" -a -d "${1}" ; then
    # If we were passed an actual path, then we have our target
    # This will happen if the path was completed on the commandline
    # when we were called.
    selected="${1}"
  else
    # We were not passed a path or at least not a complete/valid one
    # Run fzf to allow the user to select one.
    selected=$(${HOME}/.bin/jumplist.sh -f ${(z)1:+-- --query=${1}})
    test $? -ne 0 && return $?
    # Expand tilde
    selected=${selected:s/~/${HOME}/}
  fi
  test -z "${selected}" && return 0
  cd ${selected}
}

alias j=jump
