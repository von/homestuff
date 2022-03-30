#!/bin/zsh
#
# Clear screen and scrollback history

clear-output() {
  if test -n "${TMUX}" ; then
    tmux send-keys -R  # Clears screen
    tmux clear-history
    echo "tmux scrollback cleared."
  elif test -n "${TERM_PROGRAM}" -a "${TERM_PROGRAM}" = "iTerm.app" ; then
    printf $ITERM_CLEAR_SCROLLBACK
    clear
    echo "iTerm scrollback cleared."
  else
    clear
    echo "Screen cleared."
  fi
}
