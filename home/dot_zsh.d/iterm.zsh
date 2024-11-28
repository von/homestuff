#!/bin/zsh
#
# Configuration for iTerm
#
# For escape codes see:
# https://iterm2.com/documentation-escape-codes.html

# iterm_shell_integration loaded in ../zshrc if we are in
# iTerm but not in tmux
# https://iterm2.com/documentation-shell-integration.html

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
  ITERM_CURSOR_BLOCK="\e]1337;CursorShape=0\a"
  ITERM_CURSOR_VERTICAL_BAR="\e]1337;CursorShape=1\a"
  ITERM_CURSOR_UNDERLINE="\e]1337;CursorShape=2\x7"
  ITERM_CLEAR_SCROLLBACK="\e]1337;ClearScrollback\a"

  reset() {
    # Also reset cursor shape
    /usr/bin/reset
    printesc $ITERM_CURSOR_BLOCK
  }

  # Set tab background color. Will only be visible if more than
  # one tab is open.
  iterm_set_chrome_background() {
    if test $# -eq 0 ; then
      # Reset to default
      printosc "6;1;bg;*;default"
    else
      # Arguments are Red, Green, Blue
      # Carriage returns needed here to separate sequences
      printosc "6;1;bg;red;brightness;${1}\n"
      printosc "6;1;bg;green;brightness;${2}\n"
      printosc "6;1;bg;blue;brightness;${3}\n"
    fi
  }
  set_iterm_badge() {
    printosc "1337;SetBadgeFormat=%s" $(echo -n "$*" | base64)
  }

  # XXX Seems to results in backslashes before whitepsace
  iterm_notification() {
    printosc "9;%s" "${(j. .)${*}}"
  }

  # Kudos: https://stackoverflow.com/questions/16768750/iterm2-get-current-session-profile
  # The first time this is run, iTerm will ask for confirmation
  set_iterm_profile() {
    printosc "50;SetProfile=%s" "$1"
  }

  # Kudos: https://stackoverflow.com/a/34452331/197789
  # XXX This seems to always return the profile the window
  #     was created with rather than the active profile.
  get_iterm_profile() {
    osascript <<-EOF
    tell application "iTerm2"
      get profile name of current session of current window
    end tell
EOF
  }
fi

