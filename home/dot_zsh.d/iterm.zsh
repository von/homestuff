#!/bin/zsh
#
# Configuration for iTerm

# Determine if we are running within iTerm...
if test -n "${ITERM_PROFILE}" ; then

  # Open new tab in iTerm with given command
  # Kudos: https://gist.github.com/bobthecow/757788
  tab() {
    cmd="${(j. .)${(q)@}}"

    if test -n "${cmd}" ; then
      cmdstr="command \"${cmd}\""
    else
      cmdstr=""
    fi

    osascript <<-EOF
    tell application "iTerm2"
      tell current window
        create tab with default profile ${cmdstr}
      end tell
    end tell
EOF
  }

  # Open new tab in iTerm with given tmux session
  tabm() {
    session=${1:-default}
    tab exec tm ${session}
  }
  # tabm completes same as tm
  compdef _tm tabm=tm

  # Proprietary iTerm escape codes
  # https://www.iterm2.com/documentation-escape-codes.html
  ITERM_CURSOR_BLOCK="\e]50;CursorShape=0\007"
  ITERM_CURSOR_VERTICAL_BAR="\e]50;CursorShape=1\007"
  ITERM_CURSOR_UNDERLINE="\e]50;CursorShape=2\007"
  ITERM_CLEAR_SCROLLBACK="\e]50;ClearScrollback\007"

  reset() {
    # Also reset cursor shape
    /usr/bin/reset
    printesc $ITERM_CURSOR_BLOCK
  }

  set_iterm_badge() {
    printesc "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$*" | base64)
  }
fi

