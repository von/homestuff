#!/bin/zsh
#
# Increases last number on commandline before cursor
# Meant for incrementing numbers in filenames
# Kudos: http://leahneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html

_increase_number() {
  local -a match mbegin mend
  [[ $LBUFFER =~ '([0-9]+)[^0-9]*$' ]] &&
    LBUFFER[mbegin,mend]=$(printf %0${#match[1]}d $((10#$match+${NUMERIC:-1})))
}
zle -N increase-number _increase_number
# bindkey '^Xa' increase-number
# This gets last command in history and increments the last number
# bindkey -s '^Xx' '^[-^Xa'
