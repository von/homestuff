#!/bin/sh
# Use make-virtualenvs to create all my virtuals as defined
# in dot_virtualenvs.conf
#
# make-virtualenvs:
# https://github.com/von/scripts/blob/main/make-virtualenvs.py
# May not be installed yet, so check.
if (( $+commands[make-virtualenvs] )) ; then
  make-virtualenvs create || exit 1
else
  echo "make-virtualenvs not found."
fi
exit 0
