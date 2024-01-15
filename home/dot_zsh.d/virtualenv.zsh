#!/bin/zsh
#
# Setup for virtualenv
# I store virtualenvs in ~/.virtualenvs but don't use virtualenvwrapper any more
# (even though I still use WORKON_HOME).
# Virtualenvs are created by ../../scripts/make-virtualenvs.py and
# ../../virtualenvs.conf
WORKON_HOME=${HOME}/.virtualenvs

# Don't allow installs into by base python install
# Kudos: http://docs.python-guide.org/en/latest/dev/pip-virtualenv/
export PIP_REQUIRE_VIRTUALENV=true
# Don't change $PS1, I'll handle prompt changes
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Make --respect-virtualenv the default
# See https://groups.google.com/forum/#!topic/python-virtualenv/rJ9M5ZE1mZg
export PIP_RESPECT_VIRTUALENV=true


# Create a virtualenv
# https://docs.python.org/3/library/venv.html
#
# Meant for creating temporary virtualenvs for testing.
# To create a persistent virtualenv, add it to ~/.virtualenvs.conf
# and run make-virtualenvs
function make-virtualenv()
{
  python3 -m venv "${1}"
}

# Work in a virtualenv
function workon()
{
  source ${WORKON_HOME}/${1}/bin/activate
}

# Autocompletion for workon()
# This is automatically picked up by fzf-completion() or fzf-completion-ext()
_fzf_complete_workon()
{
  _fzf_complete_ext -l "$@" -o '+m' -q "${prefix}" < <(
    # Avoid problems with current directory by cd'ing
    cd "${WORKON_HOME}" || exit 1
    # 'cut' gets rid of './'
    find . -type d -depth 1 | cut -c 3-
  )
}

# Run a command after disabling any virtualenv
function novenv() {
  ( if typeset -f deactivate > /dev/null ; then deactivate ; fi
    export PIP_REQUIRE_VIRTUALENV=false && ${(q)@}
  )
}
compdef _precommand novenv
