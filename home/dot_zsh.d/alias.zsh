#!/bin/sh
#
# My zsh aliases
#


alias rm='rm -i'
alias srm='srm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias h='fc -l -$((LINES-4))'  # 4 is lines of prompt + 1
alias which='type -a'

# Display a function source
# Kudos: http://stackoverflow.com/a/11478720/197789
alias func='whence -f'

alias p="pushd"
alias P="popd"

alias du='du -kh'       # Makes a more readable output.
alias df='df -PmH'      # Makes a more readable output, no inode info
                        # Note order of args is important

# What is going on? Show uptime and top 5 CPU-using processes
# TODO: The 'cut' here cuts at the edge of the screen, but loses information
# TODO: '-6' may be larger than the screen heigh
# TODO: This should probably be a function.
alias wtf="uptime; ps axwww -r -o pid,%cpu,%mem,comm | cut -c 1-${COLUMNS} | head -6"

# iTerm is configured to look for this string alert on it
# Backslashes here prevent alerting on the string in this file
alias alert='echo \#\#\#ALERT: $*'

alias te='to-env'  # From to-env.sh
alias downloads='to-env -p d "ls -1t ~/Downloads/* | head -10"'
alias dl='to-env -p d "ls -1t ~/Downloads/* | head -10"'

alias wg='wget --no-check-certificate'

# Get fingerprint of SSH public key
# Kudos: http://www.cs278.org/blog/2007/02/15/get-ssh-key-fingerprint/
alias ssh-fp='ssh-keygen -lf'

# Alias gpg2 to gpg
type -p gpg2 > /dev/null
if test $? -eq 0 ; then
    alias gpg=gpg2
fi

# Python-related aliases
alias nb='ipython notebook'

# Intuitive zmv wrapper, e.g. z *.c.orig origin/*.c
alias z='noglob zmv -W'

# Show DNS servers (Mac specific)
# Kudos: http://superuser.com/a/258154/128341
alias dns="scutil --dns | grep 'nameserver\[[0-9]*\]' | sort | uniq"

######################################################################
# Suffix aliases
# Associate a command with a file extension when file is used as a command

# MP3 commandline player
alias -s mp3=afplay
