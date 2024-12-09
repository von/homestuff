#!/bin/sh
#
# My key bindings
#
# TODO: end-of-line causes display of prompt with status of 1

# Commands available for use in the line editor are referred to as widgets.
# The standard widgets are listed in the zshzle manpage in the STANDARD WIDGETS
# section:
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

# Use vim mode
bindkey -v

# Reduce delay in responding to ESC to .1 second
# Kudos: http://dougblack.io/words/zsh-vi-mode.html
export KEYTIMEOUT=1

# Add a bunch of emacs-like key bindings to vi mode
# Kudos: http://paulgoscicki.com/archives/2012/09/zsh-vi-mode-with-emacs-keybindings/

# {{{ VI insert mode keybindings (viins)

bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^_'    undo

bindkey -M viins '^a'    beginning-of-line
bindkey -M viins '^b'    backward-word
# Treat ^C like escape
# To allow ^C handling, use ../zsh.d/plugins/ignoreinterrupt/ignoreinterrupt.plugin.zsh
bindkey -M viins "^c"    vi-cmd-mode
# For ^D handling, see ../zsh.d/plugins/ignoreeof/ignoreeof.plugin.zsh
bindkey -M viins '^e'    end-of-line
bindkey -M viins '^f'    forward-word
bindkey -M viins '^h'    backward-delete-char
# Tab (^i) bound by Aloxaf/fzf-tab - see zshrc
bindkey -M viins '^k'    kill-line
# ^l clear-screen
# ^m carriage return
bindkey -M viins '^n'    down-line-or-history
bindkey -M viins '^p'    up-line-or-history
# From plugins/fzf_history_widget
bindkey -M viins '^r'    my-fzf-history-widget
bindkey -M viins '^s'    history-incremental-pattern-search-forward
bindkey -M viins '^u'    kill-buffer
bindkey -M viins '^w'    backward-kill-word
bindkey -M viins '^y'    yank

# From ../zsh.d/plugins/increase-number/increase-number.plugin.zsh
bindkey -M viins '^x^a'  increase-number
# Select and insert path to download (from ../zsh.d/plugins/fzf_downloads_widget)
bindkey -M viins '^x^d'  fzf-download-widget
# Open current command line in editor
bindkey -M viins "^x^e"  edit-command-line
# Select and insert git commit (from ../zsh.d/plugins/fzf_git_widget)
bindkey -M viins '^x^g'  fzf-git-commit-widget
# Select and insert task spooler job id (from ../zsh.d/plugins/fzf_task_spooler_widget)
bindkey -M viins '^x^j'  fzf-task-spooler-widget
# Copy earlier arguments after an insert-last-word
# Kudos: http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey -M viins "^x^k" copy-earlier-word
# Insert last word on previous command
bindkey -M viins '^x^l'  insert-last-word
# Set mark
bindkey -M viins '^x^m'  set-mark-command
# Push current line onto stack, restoring it next prompt
bindkey -M viins '^x^p'  push-line-or-edit
# Quote from cursor to mark
bindkey -M viins '^x^q'  quote-region
# Insert git root (from ../zsh.d/plugins/fzf_git_widget)
bindkey -M viins '^x^r'  fzf-git-root-widget
# ^X^V gets to VI command mode in addition to Escape
bindkey -M viins "^x^v"   vi-cmd-mode
# Copy word prior word or prior word to last word copied
# Kudos: http://leahneukirchen.org/blog/archive/2013/03.html
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey -M viins "^x^x" copy-earlier-word

bindkey -M viins '\eOH'  beginning-of-line # Home
bindkey -M viins '\eOF'  end-of-line       # End
bindkey -M viins '\e[2~' overwrite-mode    # Insert
bindkey -M viins '\ef'   forward-word      # Alt-f
bindkey -M viins '\eb'   backward-word     # Alt-b
bindkey -M viins '\ed'   kill-word         # Alt-d

# Up/Down arrow: scroll through history (default configuration)
# (I don't care for the behavior of history-search-end)
bindkey -M viins '^[[A' up-line-or-history
bindkey -M viins '^[[B' down-line-or-history

# }}} VI Mode Keybindings (ins)

# {{{ VI command mode keybindings (vicmd)

bindkey -M vicmd '^_'    undo
bindkey -M vicmd '^a'    beginning-of-line
bindkey -M vicmd '^b'    backward-word
bindkey -M vicmd '^e'    end-of-line
bindkey -M vicmd '^f'    forward-word
# Tab bound by Aloxaf/fzf-tab - see zshrc
bindkey -M vicmd '^k'    kill-line
bindkey -M vicmd '^n'    down-line-or-history
bindkey -M vicmd '^p'    up-line-or-history
bindkey -M vicmd '^r'    history-incremental-pattern-search-backward
bindkey -M vicmd '^s'    history-incremental-pattern-search-forward
bindkey -M vicmd '^u'    kill-buffer
bindkey -M vicmd '^w'    backward-kill-word
bindkey -M vicmd '^y'    yank

# Incremental searching  with / and ?
# Kudos: http://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd '?' history-incremental-search-backward

# Unbind ':' from execute-named-command as I accidently enter ':wq' often
bindkey -M vicmd -r ':'

bindkey -M vicmd "^x^e"  edit-command-line
bindkey -M vicmd '^x^l'  insert-last-word
bindkey -M vicmd '^x^m'  set-mark-command
bindkey -M vicmd '^x^p'  push-line-or-edit
bindkey -M vicmd '^x^q'  quote-region

bindkey -M vicmd '\ef'   forward-word                      # Alt-f
bindkey -M vicmd '\eb'   backward-word                     # Alt-b
bindkey -M vicmd '\ed'   kill-word                         # Alt-d
bindkey -M vicmd '\e[5~' history-beginning-search-backward-end # PageUp
bindkey -M vicmd '\e[6~' history-beginning-search-forward-end  # PageDown

# }}}

# {{{ Command mode bindings (command)
# Used by execute-named-command (normally ':' in vicmd)

# Let me abort
bindkey -M command '^c'  send-break

# }}}

# {{{ Move to where the arguments belong.
# Kudos: http://chneukirchen.org/blog/archive/2011/02/10-more-zsh-tricks-you-may-not-know.html
after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^X1" after-first-word
after-second-word() {
  zle beginning-of-line
  zle forward-word
  zle forward-word
}
zle -N after-second-word
bindkey "^X2" after-second-word
after-third-word() {
  zle beginning-of-line
  zle forward-word
  zle forward-word
  zle forward-word
}
zle -N after-third-word
bindkey "^X3" after-third-word
# }}}

# vim:foldmethod=marker:
