#
# Configuration for password-store: http://zx2c4.com/projects/password-store/
#

# Allow extensions in ~/.password-store/.extensions/
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# This is automatically picked up by fzf-completion() or fzf-completion-ext()
# https://github.com/junegunn/fzf/wiki/Examples-(completion)#pass
# Changed +1 to +2 for cut
_fzf_complete_pass() {
  _fzf_complete_ext -l "$@" -o '+m' -q "${prefix}" < <(
    pwdir=${PASSWORD_STORE_DIR-~/.password-store/}
    # Avoid problems with current directory by cd'ing
    cd "$pwdir" || exit 1
    # 'cut' gets rid of './' then 'sed' gets rid of extension
    find . -name "*.gpg" -print |
        cut -c 3- |
        sed -e 's/\(.*\)\.gpg/\1/'
  )
}

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

compdef _pass user=pass
_fzf_complete_user() { _fzf_complete_pass "$@" }

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

compdef _pass change_pass=pass
_fzf_complete_change_pass() { _fzf_complete_pass "$@" }

# Put first line from entry to clipboard and remainder to stdout
pt() {
  if test $# -ne 1 ; then
    echo "Usage: $0 <password entry>" 1>&2
    return 1
  fi

  pass "$@" | pass-parse -c -t
}

compdef _pass pt=pass
_fzf_complete_pt() { _fzf_complete_pass "$@" }

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

if (( $+commands[percol] || $+commands[fzf] )) ; then
  # Use percol or fzf to search password store and execute pass
  ppass() {
    local store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    pushd -q "${store}"

    if (( $+commands[fzf] )) ; then
      local menu_cmd="fzf"
    else
      local menu_cmd="percol"
    fi

    local args=""
    while test $# -gt 0 ; do
      if [[ $1 == -* ]] ; then
        args="${args:+$args }$1"
        shift
      else
        break
      fi
    done

    if test $# -gt 0 ; then
      local search_string="$1"
    else
      local search_string=""
    fi

    find . -type d -name .git -prune \
      -o -name .gpg-id -prune \
      -o -ipath "*/*${search_string}*/*" -type f -print \
      -o -iname "*${search_string}*.gpg" -type f -print \
      | sed -e "s#./##" -e 's#\.gpg$##' \
      | ${menu_cmd} \
      | while read item ; do echo -n "${(q)item} " ; done \
      | xargs pass ${args}
    popd -q
  }
fi

_pass_and_clear() {
  pass ${(j. .)${(q)@}}
  read 'X?Press return to clear.'
  clear
}

# Configuration for pass-to-hammerspoon script
hpass() {
  pass-to-hammerspoon ${(q)@}
}
compdef _pass pass-to-hammerspoon=pass
_fzf_complete_pass-to-hammerspoon() { _fzf_complete_pass "$@" }
compdef _pass hpass=pass
_fzf_complete_hpass() { _fzf_complete_pass "$@" }

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

  compdef _pass tmux_pass=pass
  _fzf_complete_tmux_pass() { _fzf_complete_pass "$@" }
  compdef _pass tp=pass
  _fzf_complete_tp() { _fzf_complete_pass "$@" }
fi

