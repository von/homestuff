#!/bin/zsh
#
# Set up our ls-related aliases

# Remove aliases from oh-my-zsh
# Kudos for check: https://unix.stackexchange.com/a/408068/29832
(( ${+aliases[ls]} )) && unalias ls
(( ${+aliases[ll]} )) && unalias ll

# Use 'exa' if available
# https://the.exa.website/

if (( $+commands[exa] )) ; then
  ls="exa"
  ls_options="-F --git"

  # Options for aliases
  l_options="${ls_options}"
  ll_options="${ls_options} -l"
  la_options="-a ${ls_options}"
  lal_optoons="${la_options}"
else
  ls="ls"
  # List char after name showing type (-F)
  ls_options="-F"
  # Multi-column (-C)
  ls_options+=" -C"

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

  # Options for aliases
  l_options="${ls_options}"
  ll_options="${ls_options} -l"
  la_optoons="-A"
  lal_optoons="${la_options}"
fi

alias ls="\${ls} ${ls_options}"
alias l="\${ls} ${l_options}"

# List long (-l)
alias ll="\${ls} ${ll_options}"

# List all (-A)
alias la="ls ${la_options}"
alias lal="ll ${lal_options}"

# Follow symbolic links (-H)
alias L="ls -H"
alias LL="\ls -lH ${ll_options}"

# Show me the most recently modified files
latest() {
  local _path=${1:=.}
  # Set CLICOLOR_FORCE so ls produces color despire not outputing
  # to terminal.
  local CLICOLOR_FORCE=X
  export CLICOLOR_FORCE
  \ls -ltH ${_path} | head -10
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

# Manual modifications for exa
#  * Make dates white instead of dark blue
#  * Git modified is bright blue instead of blue
#  * User-write permission bit is yellow instead of red
#  * User-write execution bit for non-regular files is yellow instead of green
export EXA_COLORS="${LS_COLORS}:da=37:gm=1;34:uw=33:ue=33"
