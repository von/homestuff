#!/usr/bin/env zsh
# Handle my "jumplist" - a list of paths that I want to cd to.
#
# The script can either print the list for other programs to process
# (e.g. ../dot_zsh.d/jump.zsh) or run fzf to select and print a path.
#
# The list comes from ~/.jump_targets and ~/.jump_targets_local

cmd-list()
{
  local tpath=${JUMP_TARGETS_PATH:-${HOME}/.jump_targets}
  local ltpath=${JUMP_TARGETS_LOCAL_PATH:-${HOME}/.jump_targets_local}

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
  JUMP_TARGETS=( ${JUMP_TARGETS:#\#*} )

  printf '%s\n' "${JUMP_TARGETS[@]}"

  return 0
}

cmd-fzf()
{
  cmd-list | ${FZF_CMD} ${fzf_opts_array-}
}


usage()
{
  cat <<-END
Usage: $0 [<options>] -- [<fzf options>]

Options:
  -f              Select path with fzf and print [DEFAULT].
  -h              Print help and exit.
  -l              Print jump list and exit.
  -T              Force 'fzf' instead of 'fzf-tmux'

<fzf options>     Options passed to fzf (or fzf-tmux)
END
# Note 'END' above most be fully left justified.
}

# What are we doing?
# Options are: cmd-list, cmd-fzf
CMD="cmd-fzf"

# fzf command to use
if test -n "$TMUX" ; then
  FZF_CMD="fzf-tmux"
else
  FZF_CMD="fzf"
fi

while getopts ":fhlT" opt; do
  case $opt in
    f) CMD="cmd-fzf" ;;
    h) usage ; exit 0 ;;
    l) CMD="cmd-list" ;;
    T) FZF_CMD="fzf" ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

shift $(($OPTIND - 1))

# fzf_options, stored as an array
fzf_opts_array=( $@ )

${CMD}

exit $status
