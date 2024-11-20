#!/bin/zsh
#
# ZSH configuration for tmux
#

if test -n "${TMUX}" ; then
    # We are in tmux...

    TMUX_CMD_WRAPPER=""
    if (( $+commands[reattach-to-user-namespace] )) ; then
      # On Mac, make sure cut and paste works
      TMUX_CMD_WRAPPER="reattach-to-user-namespace -l"
    fi

    # tmux split and run optional command
    tmux-split() {
        local cmd="${TMUX_CMD_WRAPPER} ${(j. .)${(q)@}}"
        tmux split-window -v ${cmd}
    }

    # Space at end of alias causes next argument to be expanded
    # Kudos: http://www.acm.uiuc.edu/workshops/zsh/related/messy_global.html
    alias t='tmux-split '

    # tmux new window with optional command
    tmux-new-window() {
        local cmd="${TMUX_CMD_WRAPPER} ${(j. .)${(q)@}}"
        tmux new-window ${cmd}
    }

    # See above regarding trailing space
    alias T='tmux-new-window '

    # Display stdin in PAGER in tmux split window
    tl() {
        local tmp=$(mktemp -t tl)
        cat >> ${tmp}
        # -+F == Don't exit if single screen
        local cmd="${TMUX_CMD_WRAPPER} ${PAGER:-less} -+F ${tmp} && rm -f ${tmp}"
        tmux split-window -v ${cmd}
    }

    # Mark the start of command output
    # tmux uses "\e]133;C\e\\" as a marker though this is undocumented.
    # See: https://github.com/tmux/tmux/issues/4259
    # Kudos: https://github.com/tmux/tmux/issues/3734
    tmux-mark-command-start() {
      echo -ne $'\e]133;C\e\\\\'
    }

    add-zsh-hook preexec tmux-mark-command-start
fi

# Do a git commit in tmux by splitting a pane with the git index and
# then doing a commit in original pane.
git-tmux-commit() {
    if test -z "${TMUX}" ; then
        echo "Not in tmux."
        exit 0
    fi
    # -d = don't focus on new pane
    # -P = print pane information, so we can kill it later
    diff_pane=$(tmux split-window -d -P "git diff --cached | less -+F")
    git commit
    tmux kill-pane -t ${diff_pane}
}

alias gtc=git-tmux-commit

# Do a svn commit in tmux by splitting a pane with the svn diff and
# then doing a commit in original pane.
svn-tmux-commit() {
    if test -z "${TMUX}" ; then
        echo "Not in tmux."
        exit 0
    fi
    # -d = don't focus on new pane
    # -P = print pane information, so we can kill it later
    diff_pane=$(tmux split-window -d -P "svn diff --cached $* | less -+F")
    svn commit $*
    tmux kill-pane -t ${diff_pane}
}

alias stc=svn-tmux-commit

# Deactivate any virtualenv before running 'tm' to clean up our
# environment.
function tm() {
  novenv command tm ${(q)@}
}

if (( $+commands[tmuxp] )) ; then
  # Disable auto title to turn off tmuxp warning
  function tmuxp() {
    DISABLE_AUTO_TITLE=true command tmuxp ${(q)@}
  }

  # Function to start tmux-server
  #
  # Meant to be called from iTerm profile.
  #
  function tmux-start() {
    DISABLE_AUTO_TITLE=true command tmuxp load -y servers homestuff
  }
fi
