# jump.zsh
#

# Variables:
#  $JUMP_HOME - jump will cd here if set, otherwise $HOME
#  $JUMP_ROOT - start of find for directories if set, otherwise $HOME

function jump() {
  JUMP_HOME=${JUMP_HOME:-${HOME}}
  cd "${1:-${JUMP_HOME}}"
}

_fzf_complete_jump() {
      ~/.bin/jumplist.sh -l |\
      FZF_TMUX_HEIGHT="80%" _fzf_complete_ext \
        ${prefix:+-q ${prefix}} \
        -o "--reverse --bind=ctrl-z:ignore +m \
            --preview-window up:wrap,3 --preview \"ls -1 -d {}\""
}

alias j=jump
_fzf_complete_j() { _fzf_complete_jump }
