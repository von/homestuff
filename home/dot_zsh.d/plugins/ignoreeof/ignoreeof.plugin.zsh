#!/bin/zh
#
# Allow multiple EOFs to exit ala Bash
#
# IGNOREEEOF should be set to integer, being the number of EOFS to
# ignore befoe exiting. E.g.: IGNOREEOF=1
#
# Kudos:
# http://www.zsh.org/mla/users/2001/msg00240.html
# http://www.zsh.org/mla/users/2010/msg00317.html

bash-ctrl-d() {
  # We are at the start of an empty line?
  if [[ $CURSOR == 0 && -z $BUFFER ]]
  then
    # We are ignoring EOFs?
    [[ -z $IGNOREEOF || $IGNOREEOF == 0 ]] && exit
    # We were last widget called and are not done ignoring?
    if [[ $LASTWIDGET == bash-ctrl-d ]]
    then
      (( --__BASH_IGNORE_EOF == 0 )) && exit
    else
      : ${__BASH_IGNORE_EOF=$IGNOREEOF}
    fi
    zle -I  # Tell zle we are taking over display, redraw when we exit
    if [[ ${__BASH_IGNORE_EOF} == 1 ]] ; then
      echo "Ignoring EOF (Repeat one more time to exit)"
    else
      echo "Ignoring EOF (Repeat ${__BASH_IGNORE_EOF} times to exit)"
    fi
  else
    # Current line is not empty
    (( __BASH_IGNORE_EOF = ${IGNOREEOF} + 1 ))
    zle delete-char-or-list
  fi
}

zle -N bash-ctrl-d
setopt ignoreeof   # Needed to bind EOF to something else
bindkey -M emacs "^D" bash-ctrl-d
bindkey -M viins "^D" bash-ctrl-d
bindkey -M vicmd "^D" bash-ctrl-d
