# Extended version of fzf completion functions
# Original: /usr/local/opt/fzf/shell/completion.zsh

# {{{ fzf-completion-ext(): Extended version of fzf-completion()
#
# Modified to use fzf if command in $FZF_COMPLETION_DIR_COMMANDS (by
# default: cd, pushd, rmdir) or has function '_fzf_complete_${cmd}' defined.
# Failing that, fall back to default zsh compltion.
#
# Ignores FZF_COMPLETION_TRIGGER.
#
fzf-completion-ext() {
  local tokens cmd prefix fzf matches dir_cmds
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins

  # http://zsh.sourceforge.net/FAQ/zshfaq03.html
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
  tokens=(${(z)LBUFFER})

  # For emply lines, or if we are in the middle of the first token (presumably
  # the command), then complete as normal.
  if [ ${#tokens} -lt 1 -o ${#tokens} -eq 1 -a "${LBUFFER[-1]}" != ' ' ]; then
    zle ${fzf_default_completion:-expand-or-complete}
    return
  fi

  cmd=${tokens[1]}

  # Commands that trigger _fzf_dir_completion_ext()
  dir_cmds=(${=FZF_COMPLETION_DIR_COMMANDS-cd pushd rmdir})

  # Are we in the middle of a word?
  if [ ${#LBUFFER} -gt 0 -a "${LBUFFER[-1]}" != ' ' ]; then
    # Yes, in middle of a word.

    # prefix is the starting search query
    prefix="${tokens[-1]}"

    # lbuf is $LBUFFER with partial word removed so we replace it with
    # completion
    lbuf=${LBUFFER:0:-${#tokens[-1]}}

    # For certain partial words, we always do default completion. Namely:
    #   Any history expansion (!*)
    #   Any variable expansion ($*)
    if [[ "${prefix}" =~ "^(\!|\\$).*" ]]; then
      zle ${fzf_default_completion:-expand-or-complete}
      return
    fi

  else
    # No, not in middle of a word

    # No starting search query
    prefix=""

    # Just append completion to existing LBUFFER
    lbuf=$LBUFFER
  fi

  # Dispatch handler as follows:
  # 1) If we have a compltion function defined, use it
  # 2) else, handle if command in FZF_COMPLETION_DIR_COMMANDS
  # 3) else, handle with default zsh completion
  if eval "type _fzf_complete_${cmd} > /dev/null"; then
    eval "prefix=\"$prefix\" _fzf_complete_${cmd} \"$lbuf\""
  elif [ ${dir_cmds[(i)$cmd]} -le ${#dir_cmds} ]; then
    _fzf_dir_completion_ext "$prefix" "$lbuf"
  else
    zle ${fzf_default_completion:-expand-or-complete}
  fi
}

zle     -N   fzf-completion-ext
# To install, do something such as:
# bindkey -M viins '^I' fzf-completion-ext

#  }}} fzf-completion-ext()

# {{{ _fzf_complete_ext(): Extended version of _fzf_complete()
#
# Given a list of options on stdin, run fzf, append result to LBUFFER, and
# refresh commandline.
#
# $FZF_COMPLETION_EXT_OPTS is added to fzf's options.
#
# Key differences from _fzf_complete():
#  * Does not support _post() version of completion function, use -p
#  * Does not support $prefix, use -q instead
#  * Results are shell quoted.
#
_fzf_complete_ext() {
  local fifo fzf matches opt
  local lbuf=${LBUFFER}
  local fzf_opts=""
  local query=""
  local append=" "
  local prepend=""
  local post="cat"

  usage()
  {
    cat <<-END
  Usage: $0 [<options>]

  Options:
    -A <string>        Append <string> to matches (default is " ").
    -h                 Print help and exit.
    -l <string>        Use <string> in place of contents of \$LBUFFER
    -o <fzf options>   Options to fzf.
    -p <cmd>           Post-process each match with cmd.
    -P <string>        Prepend <string> to matches (default is "").
    -q <string>        Starting query string
END
  }

  # Leading colon means silent errors, script will handle them
  while getopts ":A:hl:o:p:P:q:" opt; do
    case $opt in
      A) append="${OPTARG}" ;;
      h) usage ; exit 0 ;;
      l) lbuf="${OPTARG}" ;;
      o) fzf_opts="${OPTARG}" ;;
      p) post="${OPTARG}" ;;
      P) prepend="${OPTARG}" ;;
      q) query="${OPTARG}" ;;
      \?) echo "Invalid option: -$OPTARG" >&2 ;;
    esac
  done

  shift $(($OPTIND - 1))

  # Use of fifo from _fzf_complete(), reason not clear
  fifo="${TMPDIR:-/tmp}/fzf-complete-fifo-$$"
  _fzf_feed_fifo "$fifo"

  [[ -n "${FZF_COMPLETION_EXT_OPTS}" ]] && fzf_opts="$FZF_COMPLETION_EXT_OPTS ${fzf_opts}"

  matches=$(cat "$fifo" | \
    __fzf_comprun ${=fzf_opts} -q "${(Q)query}" | \
    eval ${post} | \
    tr '\n' ' ' | \
    sed "s/ \$//" )
  if [ -n "$matches" ]; then
    LBUFFER="${lbuf}${prepend}${(j. .)${(q)matches}}${append}"
  fi
  zle reset-prompt
  command rm -f "$fifo"
}

# }}} _fzf_complete_ext()

# {{{ _fzf_dir_completion_ext(): Use _fzf_compgen_dir_ext()
# Arguments:
#   prefix    Word being completed.
#   lbuf      String to use for left part of commandline.
_fzf_dir_completion_ext() {
  __fzf_generic_path_completion "$1" "$2" _fzf_compgen_dir_ext \
    "" "/" ""
}
#  }}} _fzf_dir_completion_ext()

# {{{ _fzf_compgen_dir_ext(): Breadth-first directory search
# For directory hierarchies that are really deep, this gets all the top-level
# directories into the menu quickly.
# Kudos: https://unix.stackexchange.com/a/375375/29832
_fzf_compgen_dir_ext() {
  local depth=1
  # egrep is needed to detect when no files are found and we should stop.
  # sed cleans up leading "./"
  # Note arguments to sed and egrep for linebuffering to promote quick output.
  # Use both -depth and -maxdepth: -depth makes the prune work right and
  # -maxdepth speeds things up greatly by pruning the search.
  while find "$1" -name .git -prune -o -name .svn -prune \
    -o -type d -depth ${depth} -maxdepth ${depth} -print | \
    egrep --line-buffered ".*" ; do
    ((depth++))
  done | sed -l 's@^\./@@'
}

# }}}

# {{{ _fzf_path_completion_ext(): Use _fzf_compgen_path_ext()
# Arguments:
#   prefix    Word being completed.
#   lbuf      String to use for left part of commandline.
_fzf_path_completion_ext() {
  __fzf_generic_path_completion "$1" "$2" _fzf_compgen_path_ext \
    "-m" "" ""
}
#  }}} _fzf_dir_completion_ext()

#  {{{ _fzf_compgen_path_ext(): Breadth-first path search
# For directory hierarchies that are really deep, this gets all the top-level
# directories into the menu quickly.
# Kudos: https://unix.stackexchange.com/a/375375/29832
_fzf_compgen_path_ext() {
  local depth=1
  # egrep is needed to detect when no files are found and we should stop.
  # sed cleans up leading "./"
  # Note arguments to sed and egrep for linebuffering to promote quick output.
  # Use both -depth and -maxdepth: -depth makes the prune work right and
  # -maxdepth speeds things up greatly by pruning the search.
  while find "$1" -name .git -prune -o -name .svn -prune \
    -o \( -type d -o -type f -o -type l \) \
    -depth ${depth} -maxdepth ${depth} -print | \
    egrep --line-buffered ".*" ; do
    ((depth++))
  done | sed -l 's@^\./@@'
}

#  }}}

# {{{ _fzf_complete_kill(): Completion for 'kill' command
# Needed as its functionality is not included in _fzf_completion_ext()
# as it is with _fzf_completione()
_fzf_complete_kill() {
  FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-50%} --min-height 15 --reverse $FZF_DEFAULT_OPTS --preview 'echo {}' --preview-window down:3:wrap $FZF_COMPLETION_OPTS" _fzf_complete '+m' "$@" < <(ps -ef | sed 1d)
}

_fzf_complete_kill_post() {
  awk '{print $2}' | tr '\n' ' '
}

# }}} _fzf_complete_kill()

# vim:foldmethod=marker:
