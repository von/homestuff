#!/bin/zsh
#
# Widget to use fzf to select a git commit
# Kudos: https://gist.github.com/junegunn/f4fca918e937e6bf5bad
_fzf_git_commit_widget() {
  # Make sure we're in a git repo
  [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
  test $? -ne 0 && return

  local selected=$( \
    git log --pretty=oneline --abbrev-commit --color=always --decorate=full  | \
    fzf --no-sort --ansi \
      --bind=right:preview-page-down,left:preview-page-up \
      --preview="git show --color=always \$(echo {} | cut -d ' ' -f 1)" \
      --preview-window=top:50% |\
    cut -d ' ' -f 1  )
  if test -n "${selected}" ; then
    LBUFFER=${LBUFFER}${selected}
  fi
}
zle -N fzf-git-commit-widget _fzf_git_commit_widget

# Insert path to git root
_fzf_git_root_widget() {
  # Make sure we're in a git repo
  [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
  test $? -ne 0 && return

  local root=$(git rev-parse --show-toplevel)
  if test -n "${root}" ; then
    LBUFFER=${LBUFFER}${root}
  fi
}
zle -N fzf-git-root-widget _fzf_git_root_widget
