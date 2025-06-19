#!/bin/sh
# Install and maintain vim-plug bundles.
#  https://github.com/junegunn/vim-plug
#  Kudos: https://github.com/junegunn/vim-plug/issues/730
#  Uses autoload/plug.vim

# XXX Do I want to upgrade for both vim and neovim?
vim=${EDITOR:-vim}

case ${vim} in
  *nvim)
    # For neovim
    # "-Es" Silent Ex mode - do not start a UI.
    vim_args="-Es"
    ;;

  *)
    # For vim:
    # "-T dumb" lets me see all the output
    # "-E" Improved Ex mode, stops complaint about output not being
    #     to a TTY.
    vim_args="-T dumb -E"
    ;;
esac

echo "Updating bundles for ${vim}"

# Call "set nomore" turns off waiting for user during output
# Need 'qall' here instead of just 'quit'
echo "Updating vim-plug"
${vim} ${vim_args} -c "set nomore|PlugUpgrade|qall"

# Need to run UpdateRemotePlugins at same time as PlugUpdate
echo "Updating vim-plug bundles"
${vim} ${vim_args} -c "set nomore|PlugUpdate!|UpdateRemotePlugins|qall"

# Not calling 'PlugClean' - do that manually.

exit 0
