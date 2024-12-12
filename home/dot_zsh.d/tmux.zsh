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

    # OSC Escape sequences for prompt and output start used by
    # 'next-prompt' and 'previous-prompt'
    TMUX_PROMPT_MARK=$'\e]133;A\e\\'
    # tmux uses "\e]133;C\e\\" as a marker though this is undocumented.
    # See: https://github.com/tmux/tmux/issues/4259
    # Kudos: https://github.com/tmux/tmux/issues/3734
    TMUX_COMMAND_OUTPUT_MARK=$'\e]133;C\e\\'

    # Mark the start of command output
    tmux-mark-command-start() {
      echo -ne ${TMUX_COMMAND_OUTPUT_MARK}
    }

    add-zsh-hook preexec tmux-mark-command-start

    # XXX I've also tried adding the tmux prompt mark using
    #     the precmd hook, but that fails unless I put the mark
    #     on a separate line. I believe this is because my prompt
    #     does a 'zle reset-prompt' which clears the mark.

    # Reproduce the output from the last run command on stdout
    # Uses the command start marks as produced my tmux-mark-command-start()
    # Kudos: https://ianthehenry.com/posts/tmux-copy-last-command/
    # XXX Piping from this into 'less' doesn't work well as less
    #     switches to the alternate screen which causes tmux to
    #     to capture from that screen.
    tmux-last-command-output() {
      # There doesn't seem to be any way to output the tux selection directly
      # to stdout, so we use a named pipe.
      local pipedir=$(mktemp -d -t tmux-lco)
      local pipefile="${pipedir}/fifo"
      mkfifo -m 600 ${pipefile}
      tmux copy-mode \; \
        send-keys -X previous-prompt -o \; \
        send-keys -X begin-selection \; \
        send-keys -X next-prompt \; \
        send-keys -X cursor-up \; \
        send-keys -X end-of-line \; \
        send-keys -X stop-selection \; \
        send-keys -X copy-pipe-and-cancel "cat > ${pipefile}"
      cat ${pipefile}
      # Clean up
      rm -f ${pipefile}
      rmdir ${pipedir}
    }

    alias lco='tmux-last-command-output'

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
fi

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
