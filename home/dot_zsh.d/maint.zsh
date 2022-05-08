#!/bin/zsh
# Configuration related to 'mysetup.py maint'
# Timestamp is used in von-ml.zsh-theme

MAINT_TIMESTAMP=${HOME}/.maint-timestamp
SETUP_PATH=${HOME}/develop/mac-config/setup.sh

maint() {
  (  # Run in subshell to avoid tainting caller environment
    if test -n "${VIRTUAL_ENV}" ; then
      if test -f ~/bin/virtualenv-deactivate.sh ; then
        source ~/bin/virtualenv-deactivate.sh
      else
        echo "virtualenv-deactivate.sh not found."
        exit 1
      fi
    fi

    if test ! -x "${SETUP_PATH}" ; then
      echo "Not found ${SETUP_PATH}"
      exit 1
    fi

    # Allow pip to install without virtualenv
    export PIP_REQUIRE_VIRTUALENV="false"

    nice -n 15 ${SETUP_PATH} && touch ${MAINT_TIMESTAMP}
  )
}
