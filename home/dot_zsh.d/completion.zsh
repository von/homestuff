# Configuration related to completion
# See http://zsh.sourceforge.net/Doc/Release/Completion-System.html

# Complete and expand
# Kudos: https://unix.stackexchange.com/a/171445/29832
zstyle ':completion:*' completer _expand _complete

# Show what is being completed
# Kudos: https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

# Group different types of results
zstyle ':completion:*' group-name ''

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
