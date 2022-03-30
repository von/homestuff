#!/bin/zsh
# Insert path to last file downloaded

_last_download() {
  local path filename
  # XXX Tilde not supported here
  path="${HOME}/Downloads/"
  filename=$(/bin/ls -t "${path:a}" | /usr/bin/head -1)
  # XXX Check for non-existant file
  path=${path}/${filename}
  # Add space to end of current commandline if needed
  test ${#LBUFFER} -gt 0 && LBUFFER=${LBUFFER% }" "
  # Quote and clean up path
  LBUFFER=${LBUFFER}${(q)path:a}
}
zle -N last-download _last_download
