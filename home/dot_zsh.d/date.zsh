#!/bin/sh
# Wrapper around date
function date() {
  if test $# -eq 0 ; then
    # Specify format to date (add GMT offset)
    command date +"%a %h %e %T %Z (%z) %Y"
  else
    command date ${(q)@}
  fi
}
