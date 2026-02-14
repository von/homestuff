#!/bin/bash
# Output the version control system root
# If not in a VCS-controled directory, output nothing and exit with status
# of 1.
# Currently handles: git

root=$(git rev-parse --show-toplevel 2> /dev/null)
if test $? -eq 0 ; then
  echo $root
  exit 0
fi
# Failed to find a root
exit 1
