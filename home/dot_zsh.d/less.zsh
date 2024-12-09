# Configuration for less

alias m=less
alias more='less'

export PAGER=less
export LESSCHARSET='utf-8'

# Options passed to less:
#  -i  Ignore case on searches
#  -j  Set lines above search results
#  -w  Highlight first "new" line after forward move
#  -z  Set default scroll (z-4 = windowsize - 4 lines)
#  -g  Only highlight last string to match search
#  -M  Long prompt string
#  -R  Allow raw ANSI escape sequences
#  -F  Quit immediately if display less than one screen of text.
#      See https://unix.stackexchange.com/q/107315/29832
#  Note: -X causes less to ignore mouse events, so I don't set it.
export LESS='-i -w -z-4 -g -M -R -j8 -F'
