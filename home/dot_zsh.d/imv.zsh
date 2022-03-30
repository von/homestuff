#!/bin/zsh
# Allow interactive renaming of files in bulk
# Kudos: http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html

imv() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared dst
    [[ $src != $dst ]] && mkdir -p $dst:h && mv -i $src $dst
  done
}

# icp: Interactive copying of files
icp() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared dst
    [[ $src != $dst ]] && mkdir -p $dst:h && cp -i $src $dst
  done
}
