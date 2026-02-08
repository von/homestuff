#!/bin/zsh
# Git-related configuration

# git-related aliases
alias gl='git -c color.ui=always lol | tail -$(($LINES - 4))'  # Screen height minus 4 lines for prompt
alias glog='git glog'
alias gi='git index'
alias gp='git stash save "Temporary stash for pull" && git pull && git stash pop'
alias gs='git status --porcelain'
alias ts='tig status'  # Start tig in status mode

# CD to root of git repo
git-root() {
 cd $(git rev-parse --show-toplevel)
}

# Get the name of the default branch (e.g. master, main)
# Kudos: https://stackoverflow.com/a/44750379/197789
git-get-default-branch() {
  git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
}

# Fix a detached head by checking out the default branch and then merging
# any commits to current head.
# Kudos: https://stackoverflow.com/a/10229202/197789
git-fix-detached-head() {
  git branch tmp-fix-detached-head
  git checkout $(git-get-default-branch)
  git merge tmp-fix-detached-head
  git branch -d tmp-fix-detached-head
}

# Remove a git submodule
# Kudos: https://gist.github.com/sharplet/6289697

git-remove-submodule() {
  local submodule_name=$(echo "$1" | sed 's/\/$//'); shift

  if git submodule status "$submodule_name" >/dev/null 2>&1; then
    :
  else
    echo "Submodule '$submodule_name' not found" 1>&2
    return 1
  fi

  git submodule deinit -f "$submodule_name" || return 1
  git rm -f "$submodule_name" || return 1

  if [ -z "$(cat .gitmodules)" ]; then
    git rm -f .gitmodules || return 1
  else
    git add .gitmodules || return 1
  fi
  return 0
}

git-ls-submodules() {
  git submodule foreach --quiet 'echo $sm_path'
}

# Add a local branch tracking remote repo (and optional branch)
git-add-tracking-branch() {
  if test $# -lt 3 -o $# -gt 4; then
    echo "Usage: $0 <branch> <remote-name> <remote-url> [<remote-branch>]" >&2
    return 1
  fi
  local branch=${1}
  local remote_name=${2}
  local remote_url=${3}
  if test $# -eq 4 ; then
    local remote_branch=${4}
  else
    local remote_branch="master"
  fi

  echo "Creating branch ${branch}"
  git checkout -b ${branch} || return 1
  echo "Setting up remote ${remote_name} -> ${remote_url}"
  git remote add ${remote_name} ${remote_url} || return 1
  echo "Fetching remote"
  git fetch ${remote_name} || return 1
  echo "Setting upstream to ${remote_name}/${remote_branch}"
  git branch --set-upstream-to=${remote_name}/${remote_branch} ${branch} || return 1
  echo "Making local branch match remote"
  git reset --hard ${remote_name}/${remote_branch} || return 1
}

# Given a URL, clone from von-fork account via SSH alias
# TODO: Check for SSH key loaded into ssh-agent
clone-von-fork() {
  test $# -eq 1 || { echo "Usage: clone-von-fork <url>" ; return 1 ; }
  url=$( echo $1 | sed "s/https:\/\/github.com\//von-forks.github.com:/" |\
    sed "s/git@github.com/git@von-forks.github.com/" )
  git clone "$url"
}

# CD to directory if given. If no argument is given, assume we are in a submodule
# and cd to root of parent git directory.
# Completion code in completions/_sub
sub() {
  if test $# -eq 0; then
    cd $(git rev-parse --show-toplevel)
    cd ..
    cd $(git rev-parse --show-toplevel)
  else
    cd "${1}"
  fi
}

# Complete arguments to git-stash-exec as a command
compdef _precommand git-stash-exec
