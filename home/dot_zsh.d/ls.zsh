#!/bin/zsh
#
# Set up our ls-related aliases

# Remove aliases from oh-my-zsh
# Kudos for check: https://unix.stackexchange.com/a/408068/29832
(( ${+aliases[ls]} )) && unalias ls
(( ${+aliases[ll]} )) && unalias ll

# List char after name showing type (-F)
ls_options="-F"
ll_options=""

case $OSTYPE in
  darwin*)
    # Mac-specific arguments
    # Colorized outpit (-G)
    # Non-printables as \xxx (-B)
    ls_options+=" -GB"

    # unit suffixes (-h)
    ls_options+=" -h"
    ;;

  *)
    ;;
esac

# Is this GNU ls?
ls --version > /dev/null 2>&1

if test $? -eq 0; then
  # Turn on color
  ls_options+=" --color=auto"

  # Dont display backup files (ending in ~)
  ls_options+=" -B"

  # Show human-readable sizes
  ls_options+=" -h"
fi

# Multi-column (-C)
alias ls="ls -C ${ls_options}"
alias l="ls"

# List long (-l)
alias ll="\ls -l ${ls_options} ${ll_options}"

# List all (-A)
alias la="ls -A ${ls_options}"
alias lal="ll -A ${ls_options} ${ll_optons}"

# Follow symbolic links (-H)
alias L="ls -H"
alias LL="\ls -lH ${ls_options} ${ll_options}"

# Show me the most recently modified files
latest() {
  local _path=${1:=.}
  # Set CLICOLOR_FORCE so ls produces color despire not outputing
  # to terminal.
  local CLICOLOR_FORCE=X
  export CLICOLOR_FORCE
  ll -ltH ${_path} | head -10
}

# Colors for colorized output
# (This works for MacOSX, not sure what else).
# See ls(1) for explanation.
# Changes from default are:
#  * Set directories to be cyan instead of blue for readability
#  * Sockets are red instead of green
#  * Executables are green instead of red
#  * World-writable directories are bold blue
export LSCOLORS=gxfxbxdxcxegedabagExEx

# Linux LS_COLORS version
# I used this to configure fzf-tab in after/completions.zsh
# Generated from LSCOLORS by https://geoff.greer.fm/lscolors/
# Kudos: https://superuser.com/a/314459/128341
export LS_COLORS="di=36:ln=35:so=31:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=1;34:ow=1;34"
