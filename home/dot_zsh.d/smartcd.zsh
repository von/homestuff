# Configuration for smartcd
# https://github.com/cxreg/smartcd

# Do our own virtualenv work because of bug in smartcd virtualenv helper
# https://github.com/cxreg/smartcd/issues/67

function smartcd_virtualenv_deactivate() {
  if typeset -f deactivate > /dev/null ; then
    smartcd inform "Deactivating virtualenv: ${VIRTUAL_ENV}"
    deactivate
  fi
}

function smartcd_virtualenv_activate() {
  if test -d "${1}" ; then
    smartcd inform "Activating virtualenv: ${1}"
    source "${1}/bin/activate"
    smartcd on-leave smartcd_virtualenv_deactivate
  else
    smartcd inform "Warning: virtualenv not found: ${1}"
  fi
}
