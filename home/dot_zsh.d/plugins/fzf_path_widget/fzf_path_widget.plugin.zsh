#!/bin/zsh

# Widget to use fzf to select a path and insert on commandline
# Base code taken from /usr/local/opt/fzf/shell/key-bindings.zsh

# {{{
# __fzfcmd(): Run fzf with tmux support is appropriate
#
__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

# }}} __fzfcmd()

# {{{
# __bfs(): Do a breadth first search
#   Arugments are passed to find
# Having this as a separate function seems to better handle the SIGPIPE if
# fzf is closed while a find is still running.
__bfs() {
  # egrep is needed to detect when no files are found and we should stop.
  # Note argument to egrep for linebuffering to promote quick output.
  # Use both -depth and -maxdepth: -depth makes the prune work right and
  # -maxdepth speeds things up greatly by pruning the search.
  # Redirect stderr to /dev/null in case of permission errors.
  local depth=1
  while find "${@}" -depth ${depth} -maxdepth ${depth} 2>/dev/null \
    | egrep --line-buffered ".*" ; do
    ((depth++))
  done
}

# }}}

# {{{
# fzf-path-widget(): Widget to use fzf to select and insert path
__path_sel_with_prefix() {
  # If we're in the middle of word, grab that word and use as starting query
  local prefix=""
  if [ ${#LBUFFER} -gt 0 -a "${LBUFFER[-1]}" != ' ' ]; then
    local tokens=(${(z)LBUFFER})
    prefix=${tokens[-1]}
  fi

  # XXX Why are these set?
  # setopt localoptions pipefail 2> /dev/null

  # sed cleans up leading "./"
  __bfs . \( -name .git -o -name .svn \) -prune \
    \( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \) -prune \
    -o \( -type d -o -type f -o -type l \) \
  | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS" $(__fzfcmd) -m -q "${prefix}" "$@" | while read item; do
    echo -n "${(q)item} "
  done
  return 0
}

fzf-path-widget() {
  LBUFFER="${LBUFFER}$(__path_sel_with_prefix)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-path-widget
# Use use, do something such as:
# bindkey '^T' fzf-path-widget
# }}}

# vim:foldmethod=marker:
