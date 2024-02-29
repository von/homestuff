#!/bin/zsh
# Widget to use fzf to select a file from ~/Downloads/ and insert

_fzf_download_widget() {
  local selected
  local fzfcmd
  local fzfopts

  # fzf command to use
  if test -n "$TMUX" ; then
    fzfcmd="fzf-tmux"
    # popup window at bottom of pane and fill pane
    fzfopts="-x P -y P -w $(tmux display -p '#{pane_width}') -h $(tmux display -p '#{pane_height}')"
  else
    fzfcmd="fzf"
  fi

  # Combination of '-d' and '--with-nth=-1' prunes path from displayed files
  selected=$(\ls -1t  ~/Downloads/* | \
    FZF_DEFAULT_OPTS='--scheme=path -d / --with-nth=-1 --preview="ls -l {}" --preview-window=top:2' \
    ${fzfcmd} ${fzfopts-} )
  local ret=$?
  if test -n "${selected}" ; then
    # Quote and clean up path
    LBUFFER=${LBUFFER}${(q)selected:a}
    zle reset-prompt
  fi
  return $ret
}
zle -N fzf-download-widget _fzf_download_widget
