#!/usr/bin/env zsh
# Static directory names
# These names can be used as in 'cd ~name'
# If CDABLE_VARS is set, they can even be used as 'cd name'
#
# See https://zsh.sourceforge.io/Doc/Release/Expansion.html#Static-named-directories
# Kudos: https://stackoverflow.com/a/28732211/197789

# BOOKMARKS is defined in bookmarks.zsh

# Use anonymous function to scope temporary variables.
# See: https://zsh.sourceforge.io/Doc/Release/Functions.html#Anonymous-Functions
function {
  local n  p
  for n p in ${(kv)BOOKMARKS}; do
    hash -d ${n}=${~p}
  done
}
