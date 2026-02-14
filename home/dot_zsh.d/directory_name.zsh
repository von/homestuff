# zsh_directory_name()
# In a nutshell: the form "~[name]" is treated as a dynamic directory name, which
# is convered into a path. The following function converts names to paths, vice
# See:
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Dynamic-named-directories
# https://www.zsh.org/mla/users/2015/msg00963.html

# Current dynamic directory names implemented:
#   g:<directory>    ~/Google Drive/My Drive/<directory>

zsh_directory_name() {
  test $# -ge 1 || return 1

  setopt extendedglob

  # Google drive prefix matched by 'g:'
  # Must end with a slash
  local gdrive="/Users/von/Google Drive/My Drive/"


  # Function. Should be d,n, or c
  local f=$1 ; shift

  if [[ $f = d ]]; then
    # turn the directory into a name
    test $# -ge 1 || return 1
    local path=$1 ; shift
    typeset -ga reply
    # reply should contain two elements: the first is the dynamic name for the directory
    # (as would appear within ‘~[...]’), and the second is the prefix length of the
    # directory to be replaced
    if [[ $~path = (#b)(${gdrive})([^/]##)* ]]; then
      typeset -ga reply
      reply=(g:$match[2] $(( ${#match[1]} + ${#match[2]} )) )
    else
      return 1
    fi

  elif [[ $f = n ]]; then
    # turn the name into a directory
    test $# -ge 1 || return 1
    local name=$1 ; shift
    [[ $name != (#b)g:(?*) ]] && return 1
    typeset -ga reply
    # reply should contain a single element which is the directory corresponding to the name
    reply=(${gdrive}/$match[1])

  elif [[ $f = c ]]; then
    # complete names
    # See https://zsh.sourceforge.io/Doc/Release/Completion-System.html
    local expl
    local -a dirs
    dirs=(${gdrive}/*(/:t))
    dirs=(g:${^dirs})
    _wanted dynamic-dirs expl 'dynamic directory' compadd -S\] -a dirs
    return
  else
    # Unrecognized character
    return 1
  fi
  return 0
}
