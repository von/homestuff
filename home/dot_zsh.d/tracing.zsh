#!/bin/zsh

# tracing -- run zsh function with tracing
# Argument: Function to run
#
# Kudos: http://chneukirchen.org/dotfiles/.zshrc
tracing() {
  local f=$1; shift
  functions -t $f
  $f "$@"
  functions +t $f
}
