#!/bin/zsh

# indir <directory> <command> - Execute <command> in <directory>
# Use 'indir' instead of 'in' to avoid confusion with keyword
function indir() {
  test $# -gt 1 || { echo "Usage $0: <dir> <cmd>" ; return 1 ; }
  local dir=$1; shift ;
  (cd ${dir} && eval "${(q)@}")
}

# Autocompletion for indir()
# Kudos: sudo completion function
function _indir() {
  _arguments \
    '1:dir: _path_files -/' \
    '2:command:->cmd' \
     '*::arguments:->args'
  local dir=$line[1]
  case $state in
  cmd)
    # Handle arguments in context of directory
    if test -d ${dir} ; then
      pushd -q ${dir} && { _command_names -e ; popd -q ;}
    else
      _message -r "Unknown directory \"${dir}\""
    fi
    ;;
  args)
    # Handle arguments in context of directory
    if test -d ${dir} ; then
      pushd -q ${dir} && { _normal ; popd -q ;}
    else
      _message -r "Unknown directory \"${dir}\""
    fi
    ;;
  esac
}
compdef _indir indir

alias i=indir
