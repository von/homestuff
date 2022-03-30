#!/bin/zsh
#
# Colonlist
#
# Functions for manipulation colon-separated lists (e.g. PATH)


# Usage: prepend <VAR> <path>
# Prepend path, if it exists, to colon-separated list in VAR
prepend() { [ -d "$2" ] && eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1 ; }

# Usage: prepend <VAR> <path>
# Append path, if it exists, to colon-separated list in VAR
append() { [ -d "$2" ] && eval $1=\"\$\{$1:+\$$1':'\}$2\" && export $1 ; }

# Usage: remove <VAR> <path>
# Remove path, if it exists, from colon-separated lsit in VAR
remove() {
  # Convert colon-separated list into a CR-separated list,
  # remove element and then convert back into colon-separated list.
  # (P) Flag de-references variable
  # Final sed cleans up trailing colon
  eval ${1}=$(echo ${(P)1//:/\\n} | grep -v -x "${2}" | tr "\n" ":" | sed "s/:$//")
}
