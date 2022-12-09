#!/bin/zh
# Implement a stack
# Each stack is stored in a directory as sequentially numbered files.
# No other files should be stored in the directory.

# Pop last added contents from stack and output to stdout
# Arguments: None
# Returns:
#   On success outputs contents to stdout, returns 0
#   On error, outputs error message to stderrr, returns 1
#   If stack is empty (or path doesn't exist), outputs nothings, returns 1.
pop() {
  _path=~/.stacks/default/
  test -d $_path || return 1
  _latest=$( cd $_path; \ls -1 | tail -1)
  test -n "$_latest" || return 1
  (cd $_path && cat $_latest && rm -f $_latest) || return 1
  return 0
}

# Push stdin onto stack
# Arguments: None
# Returns:
#   On success, returns 0
#   On error, outputs error message to stderrr, returns 1
push() {
  _path=~/.stacks/default/
  test -d $_path || mkdir -p ${_path}
  _latest=$(cd $_path; \ls -1 | tail -1)
  test -n "$_latest" || _lastest=0
  test "$_lastest" = "99999" && { echo "Overflow" 1>&2 ; return 1 }
  _latest=$(printf "%05d" $(($_latest+1)))
  (cd $_path && cat > $_latest) || return 1
  return 0
}

# Display stack
# Arguments: None
# Returns: Nothing
stack() {
  _path=~/.stacks/default/
  # "(On)" is a zsh glob modifer that reverses order
  (cd $_path && for f in *(On) ; do
      echo -n "${f}: "
      head -1 ${f}
    done)
}
