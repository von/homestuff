# Set Window and Tab title
# (Or pane title if we are in tmux)

# user@host:working-dir
ZSH_THEME_TERM_TAB_TITLE_IDLE="%n@%m:%~"

# And use same for window title
ZSH_THEME_TERM_TITLE_IDLE=${ZSH_THEME_TERM_TAB_TITLE_IDLE}

if test -n "${TMUX}" ; then
  # We are in tmux, set pane title and let tmux handle the
  # rest.

  # Disable oh-my-zsh setting window and tab title
  DISABLE_AUTO_TITLE=true

  # Set pane title
  # Use 'print -P' to handle prompt expansion
  # See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  function tmux_set_pane_title_for_prompt() {
    # printf '\033]2;%s\033\\' "${(j. .)${(q)@}}"
    noglob print -Pn '\e]2;${1}\e\\'
  }

  # Set pane title before showing prompt
  function tmux_set_pane_title_precmd() {
    tmux_set_pane_title_for_prompt "[${ZSH_THEME_TERM_TAB_TITLE_IDLE}]"
  }

  add-zsh-hook precmd tmux_set_pane_title_precmd

  # Set pane title before executing command
  # Note $1 is the whole commandline
  function tmux_set_pane_title_preexec() {
    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    local LINE="${2:gs/%/%%}"

    tmux_set_pane_title_for_prompt "<${LINE}>"
  }

  add-zsh-hook preexec tmux_set_pane_title_preexec

  # Fix window name if not set by tmux
  tmux_window_name=$(tmux display -p "#{window_name}")
  if test ${tmux_window_name} = "reattach-to-user-namespace" ; then
    tmux rename-window "$(basename ${SHELL})"
  fi
fi
