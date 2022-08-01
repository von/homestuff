# Load Smartcd
#
# Do this after loading configuration as loading smartcd will
# trigger any hooks based on cwd, and this way all configuraiton
# is available to those hooks.

SMART_CD_PATH="${HOME}/.smartcd/"
if test -f "${SMART_CD_PATH}/lib/core/smartcd" ; then
  # Load and configure smartcd
  # Normally in ~/.smartcd_config

  # Hack: If PWD ends in a '/' this causes bash_enter to be run twice
  # See https://github.com/cxreg/smartcd/issues/68
  PWD=${PWD%/}

  source ${SMART_CD_PATH}/lib/core/arrays
  source ${SMART_CD_PATH}/lib/core/varstash
  source $SMART_CD_PATH/lib/core/smartcd
fi

if typeset -f smartcd > /dev/null; then
  smartcd setup chpwd-hook
  # smartcd setup cd
  # smartcd setup pushd
  # smartcd setup popd
  # smartcd setup prompt-hook
  # smartcd setup exit-hook
  smartcd setup completion
  # VARSTASH_AUTOCONFIGURE=1
  # VARSTASH_AUTOEDIT=1
  # SMARTCD_NO_INODE=1
  # SMARTCD_AUTOMIGRATE=1
  # SMARTCD_LEGACY=1
  # SMARTCD_QUIET=1
  # VARSTASH_QUIET=1
else
  echo "smartcd not found."
fi
