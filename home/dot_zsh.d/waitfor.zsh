#!/bin/zsh
# waitfor
# Wait for a command to finish and then run another command.
# Completion code in completions/_waitfor
#
waitfor() {
  test -n "${1}" || { echo "Usage: waitfor <pid> <command>" ; return 1 ; }
  pid=${1} ; shift  # leaves command to be run in args
  sleeptime=1  # Seconds
  # Printing of my pid here allows for easy chaining of waitfor's
  echo "[$$] Waiting for pid ${pid}"
  while true ; do
    # Use this method instead of 'wait' as that only allows children
    # of the current shell to be waited on.
    # Kudos https://stackoverflow.com/a/3044045/197789
    kill -0 ${pid} >& /dev/null
    if test $? -ne 0 ; then
      # Process not running
      echo "Process ${pid} finished."
      ${(q)@}
      return $?
    fi
    sleep ${sleeptime}
  done
  # Will not get here.
}
