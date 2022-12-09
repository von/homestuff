#
# Allow for pasting files to clipboard buffer
#
# TODO: Assumes 'pbcopy' - support other pasting programs.

export PASTESPATH=$HOME/.pastes

function paste {
  test -d "$PASTESPATH" || mkdir "$PASTESPATH"
  test -f "$PASTESPATH/$1" || { echo "No such pastes file: $1" ; return 1 }
  cat "$PASTESPATH/$1" | pbcopy
  echo "$1 put in clipboard"
}

alias pb=paste

# zsh completion code
function _completepastes {
  if test -d "$PASTESPATH"; then
    reply=($(\ls $PASTESPATH))
  else
    reply=""
  fi
}

compctl -K _completepastes paste

function pastesave {
  test -d "$PASTESPATH" || mkdir "$PASTESPATH"
  pbpaste > "$PASTESPATH/$1"
  echo "clipboard saved to $1"
}

compctl -K _completepastes pastesave

# Push/pop pastes onto stack (requires my stack plugin)
function pbpush {
  pbpaste | push
}

function pbpop {
  _contents=$(pop)
  _pop_status=$?
  test $_pop_status -ne 0 && return $_pop_status
  echo $_contents | pbcopy
}

function pbplain {
  pbpaste -Prefer txt | pbcopy
}

# Clean up a hunk of text in past buffer
# Useful for copying from some PDFs
# 'fmt -s' collapses multiple spaces
function pbclean {
  pbpaste -Prefer txt | expand -t 1 | fmt -s | pbcopy
}

# vipe from moreutils homebrew formula
function pbvi {
  pbpaste -Prefer txt | vipe | pbcopy
}
