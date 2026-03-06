#!/usr/bin/env zsh
# Check repos using 'mr'
# -d ${HOME}: run from $HOME, required to work
# -m : minimal output
mr -d "${HOME}" -m status
