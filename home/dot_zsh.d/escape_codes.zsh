#!/bin/zsh
#
# Help for escape codes

if test -n "$TMUX" ; then
  # We are in tmux...

  # To pass escape codes through tmux, prepend \ePtmux;\e and append \e\\
  # http://blog.yjl.im/2014/12/passing-escape-codes-for-changing-font.html
  # Note this requires the allow-passthrough tmux option to be on or all.
  printesc() {
    fmt=$1; shift
    printf "\ePtmux;\e"$fmt"\e\\" ${(q)@}
  }
else
  printesc() {
    printf ${(q)@}
  }
fi

# Create attr hash table
typeset -A attr
attr[reset]="\e[0m"
attr[bold]="\e[1m"
attr[italic]="\e[3m"
attr[underline]="\e[4m"
attr[strike]="\e[9m"

# Test various text attributes
# See
# https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
# https://github.com/tmux/tmux/issues/1137

text-attr-test() {
  echo -e "The following text should be ${attr[bold]}bold${attr[reset]}"
  echo -e "The following text should be ${attr[italic]}in italics${attr[reset]}"
  echo "The following text should be `tput sitm`in italics`tput ritm` via tput"
  echo -e "The following text should be ${attr[underline]}underline${attr[reset]}"
  echo -e "The following text should be ${attr[strike]}strikethrough${attr[reset]}"
}
