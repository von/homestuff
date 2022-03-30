#!/bin/sh
# Install and maintain vim-plug bundles.
#  https://github.com/junegunn/vim-plug
#  Kudos: https://github.com/junegunn/vim-plug/issues/730
#  Uses autoload/plug.vim

# For vim:
# "-T dumb" lets me see all the output
# "-E" Improved Ex mode, stops complaint about output not being
#     to a TTY.
# Call "set nomore" turns off waiting for user during output
# vim='vim -T dumb -E'

# For neovim
# "-Es" Silent Ex mode - do not start a UI.
vim='nvim -Es'

echo "Updating vim-plug"
${vim} -c "set nomore|PlugUpgrade|qall"

echo "Updating vim-plug bundles"
# Need 'qall' here instead of just 'quit'
${vim} -c "set nomore|PlugUpdate!|qall"

# This is needed with some frequency so that deoplete completes utilisnips
echo "Running UpdateRemotePlugins"
${vim} -c "set nomore|UpdateRemotePlugins|qall"

# Not calling 'PlugClean' - do that manually.

exit 0
