# Configuration related to completion
# See http://zsh.sourceforge.net/Doc/Release/Completion-System.html

# In after/ so it runs after load of fzf-tab via antigen

# Complete and expand
# Kudos: https://unix.stackexchange.com/a/171445/29832
zstyle ':completion:*' completer _expand _complete

# fzf-tab loaded by antigen in ~/.zshrc
if test -n "${FZF_TAB_HOME}" ; then
  # Kudos: https://github.com/Aloxaf/fzf-tab
  # https://github.com/Aloxaf/fzf-tab/wiki/Configuration
  
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false

  # set descriptions format to enable group support
  zstyle ':completion:*:descriptions' format '[%d]'

  # set list-colors to enable filename colorizing
  # Note this requires LS_COLORS from ../ls.zsh
  # Kudos: https://superuser.com/a/314459/128341
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

  # switch group using left and right arrow keys
  zstyle ':fzf-tab:*' switch-group LEFT RIGHT

  if test -n "$TMUX" ; then
    # Use tmux for completion
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  fi
else
  # Configuration when not using fzf-tab

  # Show what is being completed
  # Kudos: https://thevaluable.dev/zsh-completion-guide-examples/
  zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

  # Group different types of results
  zstyle ':completion:*' group-name ''
fi

# Automatic menu completion for kill
# Kudos: http://grml.org/zsh/zsh-lovers.html
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# If a directory component matches an existing directory then
# do not try to find other completions.
# This speeds up completions for remote filesystems.
# Kudos: http://unix.stackexchange.com/a/162145/29832
zstyle ':completion:*' accept-exact-dirs true

# Don't complete backup files as commands.
# Kudos: http://chneukirchen.org/dotfiles/.zshrc
zstyle ':completion:*:complete:-command-::*' ignored-patterns '*\~'

# XXX The following breaks zsh-syntax-highlighting
# Quote stuff that looks like URLs automatically.
# Kudos: http://chneukirchen.org/dotfiles/.zshrc
# autoload -U url-quote-magic
# zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
# zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='  # dropped { }
# zle -N self-insert url-quote-magic
