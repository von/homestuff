# Configuration for less

alias m=less
alias more='less'

export PAGER=less
export LESSCHARSET='utf-8'

# Options passed to less:
#  -i  Ignore case on searchers
#  -j  Set lines above search results
#  -w  Highlight first "new" line after forward move
#  -z  Set default scroll (z-4 = windowsize - 4 lines)
#  -g  Only highlight last string to match search
#  -M  Long prompt string
#  -R  Allow raw ANSI escape sequences
#  Note: -F causes less not to display files less than one screenfull
#           due to termcap initialization clearing the screen
#  Note: -X causes less to ignore mouse events, so I don't set it.
export LESS='-i -w -z-4 -g -M -R -j8'
