#!/bin/sh
# Note that a number of homebrew environment variables are set up in ../zshrc
# since we need them earlier.

# Don't let me run 'brew install' in a virtualenv
# Per https://docs.brew.sh/Homebrew-and-Python
function brew() {
  # Look for 'install' in arguments
  # Kudos: https://stackoverflow.com/a/5203740/197789
  if [[ ${@[(r)install]} == install ]] ; then
    if test -n "${VIRTUAL_ENV}" ; then
      echo "Do not run 'brew install' in a python virtualenv."
      return 1
    fi
  fi

  command brew ${(q)@}
}
