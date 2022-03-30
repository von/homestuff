# fzf configuration
# Kudos: https://github.com/junegunn/fzf/wiki/Examples

if test -n "${TMUX}" ; then
  # Use a tmux pane for fzf
  export FZF_TMUX=1
fi

# Default FZF_DEFAULT_OPTS
export FZF_DEFAULT_OPTS=""
# Bind ^f and ^b to page up and down
FZF_DEFAULT_OPTS+="--bind=ctrl-b:half-page-up,ctrl-f:half-page-down"
# ^k kills to end of line, ^u cleans line (aborts if line empty)
FZF_DEFAULT_OPTS+=" --bind=ctrl-k:kill-line,ctrl-u:cancel"
# Alt-shift-arroes move preview window
FZF_DEFAULT_OPTS+=" --bind=alt-shift-up:preview-up,alt-shift-down:preview-down"
FZF_DEFAULT_OPTS+=" --bind=alt-shift-left:preview-page-up,alt-shift-right:preview-page-down"

# Extra options for _fzf_complete_ext()
# These are the options _fzf_complete() adds by default
FZF_COMPLETION_EXT_OPTS="--reverse"
if test -z "${TMUX}" ; then
  # Within TMUX fzf-tmux is called, which uses FZF_TMUX_HEIGHT instead of --height
  FZF_COMPLETION_EXT_OPTS+=" --height ${FZF_TMUX_HEIGHT:-40%}"
fi

# Don't use fzf by default with cd, pushd, and rmdir
FZF_COMPLETION_DIR_COMMANDS=""

# Fuzzy-cd
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Fuzzy word look up
dict() {
  cat /usr/share/dict/words | fzf -q "$1"
}
