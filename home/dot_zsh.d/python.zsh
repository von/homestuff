#!/bin/zsh
#
# ZSH configuration for python
# See also virtualenv.zsh
#
if test -e "$HOME/.pythonrc" ; then
  export PYTHONSTARTUP="$HOME/.pythonrc"
fi

# Install package in development mode
# https://setuptools.pypa.io/en/latest/userguide/development_mode.html
function pip-dev-install()
{
  pip install --editable .
}

# Create a virtualenv
# https://docs.python.org/3/library/venv.html
function make-virtualenv()
{
  python3 -m venv "${1}"
}
