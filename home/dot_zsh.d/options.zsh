#!/bin/zsh
#
# Zsh options
#
# See 'man zshoptions'
#
# Option names are case-insensitive and underscores are ignored.
# 'unsetopt opt' 'setopt noopt' and 'setopt +o opt' are equivalent
#
# Kudos: https://callstack.com/blog/supercharge-your-terminal-with-zsh/

## Respect comments (#) on in interactive commands
setopt INTERACTIVE_COMMENTS

# Directory stack {{{
#
# Don't push directories onto stack when cd'ing
setopt NO_AUTOPUSHD

# Set stack size (not an option)
DIRSTACKSIZE=10

# }}} Directory stack

# Don't use variables in directory shown in prompt {{{
setopt NO_AUTONAMEDIRS
# }}} Don't use variables in directory shown in prompt

# History {{{

# Append to, don't replace history file
# (It will be automatically pruned from time to time)
setopt APPEND_HISTORY

# Save each command's beginning timestamp (in seconds since the epoch)
# and the duration (in seconds) to the history file.
setopt EXTENDED_HISTORY

# Don't share history between shells
setopt NO_SHARE_HISTORY

# }}} History
