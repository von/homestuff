#!/usr/bin/env zsh
# Update vim bundles
#
echo "Updating vim bundles..."
/bin/sh ~/.vim/vim-bundle-update.sh || return 1
echo "Success."
return 0  # Script is sourced - return not exit
