#!/usr/bin/env zsh
# Handle my "jumplist" - a list of paths that I want to cd to.
#
# The script can either print the list for other programs to process
# (e.g. ../dot_zsh.d/jump.zsh) or run fzf to select and print a path.
#
# The list comes from ~/.jump_targets and ~/.jump_targets_local

# Format for cmd-list().
#   %path will be converted into full path
#   %name will be converted into key
list_format="%path"

# Read jump list from files into associate array JUMP_TARGETS
_read_jump_list()
{
  local tpath=${JUMP_TARGETS_PATH:-${HOME}/.jump_targets}
  local ltpath=${JUMP_TARGETS_LOCAL_PATH:-${HOME}/.jump_targets_local}

  typeset -Ag JUMP_TARGETS=()

  for file in ${tpath} ${ltpath} ; do
    if test -f ${file} ; then
      while read -r key value; do
        if [[ ${key} == \#* ]] ; then
          : # comment
        else
          JUMP_TARGETS[$key]="$value"
        fi
      done < ${file}
    fi
  done

  # success. JUMP_TARGETS set.
}

# List jumplist directories
cmd-list()
{
  _read_jump_list  # Sets JUMP_TARGETS

  for name path in ${(kv)JUMP_TARGETS}; do
    echo ${list_format:gs/%name/$name/:gs/%path/$path/}
  done

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
  -F <fmt>        Use fmt for list (defaule: ${list_format}
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

while getopts ":fF:hlT" opt; do
  case $opt in
    f) CMD="cmd-fzf" ;;
    F) list_format=${OPTARG} ;;
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
