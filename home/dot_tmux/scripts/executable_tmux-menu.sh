#!/usr/bin/env bash
#
# tmux-menu.sh
#
# Drive a tmux menu
#
# Kudos for the concept:
# https://github.com/jaclu/tmux-menus

SELF="$0"
MENU="${1:-DEFAULT}"
ARGS=""

# Session name of popup session
POPUP_SESSION="popup"

case "$MENU" in
  DEFAULT)
    tmux display-menu -T "#[align=centre] TMUX Menu" $ARGS \
      Panes                             p "run-shell \"${SELF} PANES\"" \
      Windows                           w "run-shell \"${SELF} WINDOWS\"" \
      Session                           s "run-shell \"${SELF} SESSION\"" \
      Server                            S "run-shell \"${SELF} SERVER\"" \
      "Choose session"                   t "run-shell \"${SELF} SESSIONS\"" \
      "" \
      "List key bindings"               k "list-keys"
    ;;

  PANES)
    tmux display-menu -T "Pane Menu" $ARGS \
      "#{?pane_marked,Unmark,Mark} current pane" m  "select-pane -m"  \
      "Break pane into own Window"      b "break-pane -n 'default'" \
      "Join pane into this window"      j "choose-window 'join-pane -s %%'" \
      "Swap pane with prev"             p "swap-pane -U" \
      "Swap pane with next"             n "swap-pane -D" \
      "#{?pane_marked_set,,-}Swap current pane with marked"  s  swap-pane \
      "" \
      "-Layouts" "" "" \
      "Even-horizontal"                 h "select-layout even-horizontal" \
      "Even-vertical"                   v "select-layout even-vertical" \
      "Main-horizontal"                 H "select-layout main-horizontal" \
      "Main-vertical"                   V "select-layout main-vertical" \
      "Tiled"                           t "select-layout tiled" \
      "" \
      "#{?pane_synchronized,Uns,S}ynchronize panes"  S  "set -w synchronize-panes"  \
      "" \
      "Back"                            x "run-shell \"${SELF} DEFAULT\""
    ;;

  SERVER)
    tmux display-menu -T "Server Menu" $ARGS \
      "Reload configuration"            r "source-file ~/.tmux.conf" \
      "Show messages"                   s show-messages \
      "Customize options"               C "customize-mode -Z"  \
      "" \
      "Kill server"                     K "confirm-before -p \"kill tmux server on #H ? (y/n)\" kill-server"  \
      "" \
      "Back"                            x "run-shell \"${SELF} DEFAULT\""
    ;;

  SESSION)
    tmux display-menu -T "Session Menu" $ARGS \
      "Choose Session"                  c "choose-tree -s -Z" \
      "Last selected session"           l "switch-client -l" \
      "Previous session"                p "switch-client -p" \
      "Next session"                    n "switch-client -n" \
      "" \
      "Detach"                          d "detach-client" \
      "Rename this session"             r "command-prompt -I \"#S\" \"rename-session -- '%%'\""  \
      "New session"                     N "command-prompt -p \"Name of new session: \" \"new-session -c ~ -n '%1' -s '%1'\""  \
      "Kill current session"            k "confirm-before -p \"Are you sure you want to kill this session? (y/n)\" \"kill-session\""  \
      "Kill all other sessions"         o "confirm-before -p \"Are you sure you want to kill all other sessions? (y/n)\" \"kill-session -a\""  \
      "" \
      "Back"                            x "run-shell \"${SELF} DEFAULT\""
    ;;

  SESSIONS)  # Create dynamic list of active and tmuxp sessions
    _current_session=$(tmux display-message -p '#S')
      _menu="tmux display-menu -T \"Choose session\" $ARGS "
    if test "${_current_session}" = "${POPUP_SESSION}" ; then
      _menu+="\"*Close popup*\" \"\" \"run-shell \\\"tmuxp-popup -t ${POPUP_SESSION}\\\"\" "
    else
      # Create list of tmuxp sessions, filtering out popup session
      _tmuxp_sessions=$(cd ~/.tmuxp/ ; \
        find . -name \*.yaml -print | \
        cut -c 3- | sed -e 's/\(.*\)\.yaml/\1/' | \
        sort | grep -v "${POPUP_SESSION}" )
      # Create list of active sessions, filtering out popup session
      _active_sessions=$(tmux list-sessions -F '#{session_name}' | sort | \
        grep -v "${POPUP_SESSION}" )
      _menu+="\"*previous*\" \"\" \"switch-client -l\" "
      _menu+="\"*popup*\" \"\" \"run-shell \\\"tmuxp-popup -t ${POPUP_SESSION}\\\"\" "

      for s in ${_active_sessions} ; do
        _menu+="\"${s}\" \"\" \"switch-client -t ${s}\" "
      done
      _menu+="\"\" "
      _menu+="\"-Start tmuxp session\" \"\" \"\" "
      for s in ${_tmuxp_sessions} ; do
        _menu+="\"${s}\" \"\" \"run-shell \\\"tmuxp load -y ${s} > /dev/null\\\"\" "
      done
      _menu+="\"*New from scratch*\" \"\" \"command-prompt -p \\\"Name of new session: \\\" \\\"new-session -c ~ -n '%1' -s '%1'\\\"\" "
    fi
    _menu+="\"\" \"Back\" x \"run-shell \\\"${SELF} DEFAULT\\\"\""
    eval "${_menu}"
    ;;

  WINDOWS)
    tmux display-menu -T "Window Menu" $ARGS \
      "Last selected window"            l "last-window" \
      "Previous window (in order)"      p "previous-window" \
      "Next     window (in order)"      n "next-window" \
      "" \
      "Rename window"                   r "command-prompt -I \"#W\"  -p \"New window name: \"  \"rename-window '%%'\""  \
      "Kill current window"             K "confirm-before -p \"kill-window #W? (y/n)\" kill-window"  \
      "" \
      "Swap window Left"                \< "swap-window -dt:-1"  \
      "Swap window Right"               \> "swap-window -dt:+1"  \
      "#{?pane_marked_set,,-}With marked pane"  w  swap-window  \
      ""\
      "Back"                            x "run-shell \"${SELF} DEFAULT\""
    ;;


  *)
    tmux display-message "tmux-menu error: unknown menu ${MENU}" 1>&2
    exit 1
    ;;
esac

exit 0
