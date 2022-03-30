# jump.zsh
#
# Given a list of paths in the JUMP_TARGETS array, use completion to let me
# cd to them quickly.

typeset -a JUMP_TARGETS
# https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fmapfile-Module
zmodload zsh/mapfile

local tpath=${JUMP_TARGETS_PATH:-${HOME}/.jump_targets}
# Kudos: https://stackoverflow.com/a/12652267/197789
JUMP_TARGETS=( "${(f)mapfile[$tpath]}" )

local ltpath=${JUMP_TARGETS_LOCAL_PATH:-${HOME}/.jump_targets_local}
if test -f "${ltpath}" ; then
  JUMP_TARGETS+=( "${(f)mapfile[$ltpath]}" )
fi
# Remove comments
# Kudos: https://stackoverflow.com/a/41876600/197789
JUMP_TARGETS=( ${JUMP_TARGETS:#\#*})

# Where we currently have jumped to
JUMP_CURRENT_PATH=""

# The previous path we jumped to
JUMP_LAST_PATH=""

# Output JUMP_TARGETS, one per line
function jumplist() {
  for i ("$JUMP_TARGETS[@]") do print -r -- $i ; done
}

# Jump to given directory. If no argument given, jump to previous target.
# Argument can match last component of a path in JUMP_TARGETS, in which case
# that full path is used.
function jump() {
  local JUMP_TARGET=${1:-${JUMP_LAST_PATH}}
  if test -z "${JUMP_TARGET}" ; then
    echo "No last jump path."
    return 1
  fi
  # Expand '~'
  JUMP_TARGET="${JUMP_TARGET/\~/$HOME}"
  if test ! -d "${JUMP_TARGET}" ; then
    # See if we match the last component of a path in JUMP_TARGETS. If so, use that path.
    for d ("$JUMP_TARGETS[@]") do
      if test "$(basename ${d:q})" = "${JUMP_TARGET}" ; then
        JUMP_TARGET="${d}"
        break
      fi
    done
    # If we don't match, fall through...
  fi
  cd "${JUMP_TARGET}" || return 1
  JUMP_LAST_PATH="${JUMP_CURRENT_PATH}"
  JUMP_CURRENT_PATH="${JUMP_TARGET}"
  return 0
}

_fzf_complete_jump() {
  jumplist | _fzf_complete_ext -l "$@" -o "+m" -q "${prefix}"
}

alias j=jump
_fzf_complete_j() {
  jumplist | _fzf_complete_ext -l "$@" -o "+m" -q "${prefix}"
}
