#!/usr/bin/env zsh
# Update ~/.vifm/bookmarks with jump targets from ~/.jump_targets and
# ~/.jump_targets_local

target=${HOME}/.vifm/bookmarks.vifm
tpath=${JUMP_TARGETS_PATH:-${HOME}/.jump_targets}
ltpath=${JUMP_TARGETS_LOCAL_PATH:-${HOME}/.jump_targets_local}

# Tag to use for bookmarks
tag="jump"

# Check for newer jump targets
newer="0"
if test -f "${target}" ; then
  if test -f "${tpath}" -a "${tpath}" -nt "${target}" ; then
    newer="1"
  elif test -f "${ltpath}" -a "${ltpath}" -nt "${target}" ; then
    newer="1"
  fi
else
  if test -f "${tpath}" -o -f "${ltpath}" ; then
    newer="1"
  fi
fi

if test $newer = "0" ; then
  exit 0
fi

# One or both jump target files is newer, rebuild 'bookmarks'
#
typeset -a JUMP_TARGETS
# https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fmapfile-Module
zmodload zsh/mapfile

# Read jump_targets into JUMP_TARGETS, removing comments
# Kudos: https://stackoverflow.com/a/12652267/197789
JUMP_TARGETS=( "${(f)mapfile[$tpath]}" )

if test -f "${ltpath}" ; then
  JUMP_TARGETS+=( "${(f)mapfile[$ltpath]}" )
fi

# Remove comments
# Kudos: https://stackoverflow.com/a/41876600/197789
JUMP_TARGETS=( ${JUMP_TARGETS:#\#*})

for i ("$JUMP_TARGETS[@]") do
  echo bmark! \"${i}\" ${tag}
done > "${target}"
exit 0
