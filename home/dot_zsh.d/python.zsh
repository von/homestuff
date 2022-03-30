#!/bin/zsh
#
# ZSH configuration for python
# See also virtualenv.zsh
#
if test -e "$HOME/.pythonrc" ; then
  export PYTHONSTARTUP="$HOME/.pythonrc"
fi
