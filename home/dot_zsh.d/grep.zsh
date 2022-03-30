#!/bin/zsh

# call grep recursively with useful defaults
# Arguments: <Pattern> <Starting directory>
# 
# Kudos: http://chneukirchen.org/dotfiles/.zshrc
# With changes (s/-P/-E) to adjust for OSX
rgrep() {
  local p=$argv[-1]
  (( ARGC > 1 )) && [[ -d $p ]] && { p=$p/; argv[-1]=(); } || p=''
  LC_ALL=C grep --exclude "*~" --exclude "*.o" --exclude "tags" \
    --exclude-dir .bzr --exclude-dir .git --exclude-dir .hg --exclude-dir .svn \
    --exclude-dir CVS  --exclude-dir RCS --exclude-dir _darcs \
    --exclude-dir _build \
    -r -E ${@:?regexp missing} $p
}
