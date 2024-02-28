#!/usr/bin/env bash
# Handle my "jumplist" - a list of paths that I want to cd to.
# Currently that list is all paths under $HOME with some exceptions
# (usually lengthy lists of internal paths that add lots of bulk).
# The script can either print the list for other programs to process
# (e.g. ../dot_zsh.d/jump.zsh) or run fzf to select and print a path.

cmd-list()
{
  # -L == follow links
  find -L ${JUMP_ROOT:-${HOME}} -mindepth 1 \
    \( -fstype sysfs -o \
    -fstype devfs -o \
    -fstype devtmpfs -o \
    -fstype proc -o \
    -name .git -o \
    -name .vim-bundle -o \
    -name .virtualenvs -o \
    -path ${HOME}/.antigen -o \
    -path ${HOME}/.cache -o \
    -path ${HOME}/.cpan -o \
    -path ${HOME}/.dropbox -o \
    -path ${HOME}/.dvdcss -o \
    -path ${HOME}/.oh-my-zsh -o \
    -path ${HOME}/.password-store -o \
    -path ${HOME}/.tmux-plugins -o \
    -path ${HOME}/.Trash -o \
    -path ${HOME}/Applications -o \
    -path ${HOME}/Google\ Drive/.shortcut-targets-by-id -o \
    -path ${HOME}/Library -o \
    -path ${HOME}/Pictures/Photos\ Library.photoslibrary \) -prune \
    -o -type d -print 2> /dev/null
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

Environment variables:
  \$JUMP_ROOT      Root of paths print [DEFAULT: \$HOME]
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
