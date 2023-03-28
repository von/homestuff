#!/bin/zsh
# Allow interactive renaming of files in bulk
# Kudos: http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html

imv() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared dst
    if [[ $src != $dst ]] ; then
      mkdir -p $dst:h && mv -i $src $dst
    else
      echo "File unchanged."
    fi
  done
}

# icp: Interactive copying of files
icp() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared dst
    if [[ $src != $dst ]] ; then
      mkdir -p $dst:h && cp -i $src $dst
    else
      echo "File uncopied."
    fi
  done
}
