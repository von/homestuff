#!/bin/zsh
# Widget to use fzf to select a file from ~/Downloads/ and insert

_fzf_download_widget() {
  local selected
  # Combination of '-d' and '--with-nth=-1' prunes path from displayed files
  selected=$(\ls -1t ~/Downloads/* | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS" fzf -d / --with-nth=-1)
  if test -n "${selected}" ; then
    # Quote and clean up path
    LBUFFER=${LBUFFER}${(q)selected:a}
    zle reset-prompt
  fi
}
zle -N fzf-download-widget _fzf_download_widget
