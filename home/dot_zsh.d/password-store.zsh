#
# Configuration for password-store: http://zx2c4.com/projects/password-store/
#

# Allow extensions in ~/.password-store/.extensions/
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# Wrapper around search_pass script to put search results into
# variables for easy reference.
sp() {
    to-env -p p "search_pass ${(q)@}"
}

# Return username (assumed to be filename) of a password store
user() {
  username=$(basename ${(q)@})
  echo "Copying username '${username}' to paste buffer."
  echo -n ${username} | pbcopy
}

# Workflow for changing password
change_pass() {
  if test $# -ne 1 ; then
    echo "Usage: $0 <password entry>" 1>&2
    return 1
  fi

  local entry=$1; shift;

  pass -c "${entry}"
  read \?"Old password in clipboard. Press <Enter> to edit and create new password."
  pass edit "${entry}"
  echo "Copying new password to clipboard."
  pass -c "${entry}"
}

compdef change_pass=pass

# Put first line from entry to clipboard and remainder to stdout
pt() {
  if test $# -ne 1 ; then
    echo "Usage: $0 <password entry>" 1>&2
    return 1
  fi

  pass "$@" | pass-parse -c -t
}

compdef pt=pass

# Get previous password for entry
previous_pass() {
  local store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

  if test $# -ne 1 ; then
    echo "Usage: $0 <search_string>" 1>&2
    return 1
  fi
  local entry=$1; shift;
  local entry_gpg="${entry}".gpg

  pushd -q "${store}"

  # Commit that last changed entry
  # Kudos: http://stackoverflow.com/a/14501055/197789
  local commit=$(git log -n 1 --pretty=format:%h -- "${entry_gpg}")

  echo "Copying previous version of ${entry} (${commit}) into clipboard."
  git checkout ${commit}~1 -- "${entry_gpg}"
  pass -c "${entry}"
  git checkout HEAD -- "${entry_gpg}"
  popd -q
}

_pass_and_clear() {
  pass ${(j. .)${(q)@}}
  read 'X?Press return to clear.'
  clear
}

# Configuration for pass-to-hammerspoon script
hpass() {
  pass-to-hammerspoon ${(q)@}
}

compdef pass-to-hammerspoon=pass
compdef hpass=pass

if test -n "${TMUX}" ; then
  # Run pass in new tmux pane
  # XXX This isn't working because the shell in the new tmux pane
  #     hasn't sourced the above function.
  tmux_pass() {
    tmux-split _pass_and_clear ${(j. .)${(q)@}}
  }

  tp() {
    tmux_pass ${(j. .)${(q)@}}
  }

  compdef tmux_pass=pass
  compdef tp=pass
fi

