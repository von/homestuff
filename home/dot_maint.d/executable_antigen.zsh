#!/usr/bin/env zsh
# Update zsh antigen bundles
# antigen itself is updated by homebrew
#
echo "Updating antigen bundles..."
antigen update
if test $? -ne 0 ; then
  echo "Error running 'antigen update'"
  return $?  # Script is sourced - return not exit
fi
echo "Success."
return 0  # Script is sourced - return not exit
