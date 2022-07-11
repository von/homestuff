#!/bin/sh
# Use make-virtualenvs to create all my virtuals as defined
# in dot_virtualenvs.conf
#
# make-virtualenvs:
# https://github.com/von/scripts/blob/main/make-virtualenvs.py
make-virtualenvs create || exit 1
exit 0
