#!/bin/zsh
# Configuration for zsh-syntax-highlighting

# Change blue since it is too dark.
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=yellow
ZSH_HIGHLIGHT_STYLES[globbing]=fg=yellow

# Allow me to disable highlighting (can be slow with remote filesystems)
function zsh_disable_highlight() {
  ZSH_HIGHLIGHT_HIGHLIGHTERS=()
}
