#!/bin/zsh
#
# Configure my zsh PATH
#
# Requires colonlist plugin.
#
# In zsh, the path array and $PATH variables are linked.
# Kudos: http://unix.stackexchange.com/a/62599/29832

# Make sure I have some sort of PATH
if [ -z "${PATH}" -o -n "${RELOAD_ZSHRC}" ]; then
  # path_help, on MacOSX, creates a path based on /etc/paths.d and
  # /etc/manpaths.d
  # Kudos: http://unix.stackexchange.com/q/22979/29832
  if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
  else
    export PATH=/bin
  fi
fi

prepend PATH /usr/local/bin
prepend PATH $HOME/bin

append PATH /usr/bin
append PATH /sbin
append PATH /usr/sbin
append PATH /etc
append PATH /usr/etc
append PATH /usr/ucb
append PATH /usr/bsd
append PATH /usr/bin/X11
append PATH /usr/X11R6/bin
append PATH /usr/bsd
append PATH /usr/lang
append PATH /usr/ccs/bin
append PATH /opt/ansic/bin
append PATH /usr/X11R6/bin
append PATH /usr/local/sbin
append PATH /usr/local/bin/X11
append PATH /usr/local/bin/X11
append PATH /usr/local/krb5/bin
append PATH /sw/bin
append PATH /usr/local/mysql/bin
append PATH /opt/local/bin
append PATH /opt/local/sbin
append PATH /usr/bin/X11/games
append PATH /usr/openwin/bin
append PATH /bin/athena
append PATH /usr/texbin
append PATH /usr/local/ssl/bin

# Pick up added git commands
append PATH $HOME/.gitconf/bin

# No current directory in PATH
remove PATH .

# -U: make PATH elements unique
export -U PATH
