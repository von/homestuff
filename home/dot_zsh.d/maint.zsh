#!/bin/zsh
# Configuration related to 'mysetup.py maint'
# Timestamp is used in von-ml.zsh-theme

MAINT_TIMESTAMP=${HOME}/.maint-timestamp
MAINT_DIRECTORY=${HOME}/.maint.d
SETUP_PATH=${HOME}/develop/mac-config/setup.sh

maint() {
  (  # Run in subshell to avoid tainting caller environment
    cd ${HOME}
    if test -n "${VIRTUAL_ENV}" ; then
      deactivate || { echo "Failed to deactivate virtual." ; exit 1 ; }
    fi

    if test ! -x "${SETUP_PATH}" ; then
      echo "Not found ${SETUP_PATH}"
      exit 1
    fi

    # Allow pip to install without virtualenv
    export PIP_REQUIRE_VIRTUALENV="false"

    nice -n 15 ${SETUP_PATH} || return 0

    for file in ${MAINT_DIRECTORY}/*.zsh(.N) ; do
      echo "Executing ${file}..."
      source ${file}
    done

    touch ${MAINT_TIMESTAMP}
  )
}
