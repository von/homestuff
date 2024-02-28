# jump.zsh
#
# See ../dot_bin/executable_jumplist.sh

# Variables:
#  $JUMP_ROOT - start of find for directories if set, otherwise $HOME

function jump() {
  local selected=$(${HOME}/.bin/jumplist.sh -f ${(z)1:+-- --query=${1}})
  test $? -ne 0 && return $?
  test -z "${selected}" && return 0
  cd ${selected}
}

alias j=jump
