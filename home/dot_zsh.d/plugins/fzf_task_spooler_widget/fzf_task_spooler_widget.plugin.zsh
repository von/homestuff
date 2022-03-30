#!/bin/zsh
# Widget to use fzf to select a task id Task Spooler queue
# http://vicerveza.homeunix.net/~viric/soft/ts/

_fzf_task_spooler_widget() {
  local selected
  # Combination of '-d' and '--with-nth=-1' prunes path from displayed files
  selected=$(\ts | fzf --with-nth=1,2,6.. --header-lines=1 --reverse --exit-0 | cut -d ' ' -f 1)
  if test -n "${selected}" ; then
    LBUFFER=${LBUFFER}${selected}
  fi
}
zle -N fzf-task-spooler-widget _fzf_task_spooler_widget
