#!/bin/zsh

# absolute [FILE...] - print absolute file name/PWD
#
# Kudos: http://chneukirchen.org/dotfiles/.zshrc
absolute() {
  print -l ${${@:-$PWD}:a}
}
