#!/bin/zsh
# my-fzf-history-widget: use fzf to select a line from shell history
#
# My version of fzf's version because it is hanging on me for
# unknown reasons.
# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

_fzf_history_widget() {
  local selected
  local fzfcmd
  local fzfopts=""

  # fzf command to use
  if test -n "$TMUX" ; then
    fzfcmd="fzf-tmux"
    # popup window with 20% width and 40% heigh
    fzfopts="-w 20% -h 40%"
  else
    fzfcmd="fzf"
  fi

  # fc options:
  # -l: list history
  # -n: no event numbers
  # -r: reverse listing
  # 1: list all entries back to first
  selected=$(\fc -lnr 1 |\
    FZF_DEFAULT_OPTS="--scheme=history ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" ${fzfcmd} ${fzfopts-} )
  local ret=$?
  if test -n "${selected}" ; then
    LBUFFER="${selected}"
    zle reset-prompt
  fi
  return $ret
}
# Use my-fzf-history-widget to avoid collison with fzf's version
zle -N my-fzf-history-widget _fzf_history_widget
