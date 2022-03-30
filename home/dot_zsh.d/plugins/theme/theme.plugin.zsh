#!/bin/zsh
#
# Allow easy switching between themes
#
# Todo:
#    * Autocompletion


# Usage: theme <theme name>
theme () {
    local theme=$1
    if [ -f "${OH_MY_ZSH}/themes/${theme}.zsh-theme" ]; then
        source "${OH_MY_ZSH}/themes/${theme}.zsh-theme"
    elif [ -f "${ZSH_CUSTOM}/${theme}.zsh-theme" ]; then
        source  "${ZSH_CUSTOM}/${theme}.zsh-theme"
    else
        echo "Unknown theme '${theme}'"
    fi
}
