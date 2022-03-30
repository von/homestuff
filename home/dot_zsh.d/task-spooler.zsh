# Configuration for Task-spooler
# http://vicerveza.homeunix.net/~viric/soft/ts/

# Alias 'ts' (Task-spooler) to 'q' to avoid conflict with 'ts' alias
# for tig (and 'ts' timestamp utility in moreutils)
alias q='\ts'

# Completion function for task-spooler
function _ts() {
  local context state state_descr line
  typeset -A opt_args

  # XXX figure out how to call fzf to select a job id dynamically.
  local idlist=$(ts | sed -n '1!p' |cut -d ' ' -f 1)
  local ids=( ${(f)idlist} )

  _arguments \
    '-n[no stdout]' \
    '-g[use gzip]' \
    '-f[foreground]' \
    '-m[mail output]' \
    '-L[add label to task]:label:()' \
    '-d[run only on success of priror command]' \
    '-D[run only if given job finished successfully]:id:($ids)' \
    '-B[block if queue full]' \
    '-E[separate file for stderr]' \
    '-N[run only if num slots available]:number:()' \
    '-K[kill server]' \
    '-C[clear finished jobs]' \
    '-l[show list of jobs]' \
    '-t[tail job output]:id:($ids)' \
    '-c[cat job output]:id:($ids)' \
    '-p[show job pid]:id:($ids)' \
    '-o[show output filename]:id:($ids)' \
    '-s[show job state]:id:($ids)' \
    '-r[remove job from queue]:id:($ids)' \
    '-w[wait for job]:id:($ids)' \
    '-k[kill job]:id:($ids)' \
    '-u[make job urgent]:id:($ids)' \
    '-i[show information about job]:id:($ids)' \
    '-U[swap jobs in queue]:ids:->swap' \
    '-h[show help]' \
    '-V[show version]' \
    ':command:->cmd' \
    '*::arguments:->args'
  case ${state} in
    args) _normal ;;
    cmd) _command_names -e ;;
    swap) _sep_parts ids - ids ;;
  esac
}
compdef _ts ts

# Use fzf for completing job ids in task-spooker commands
# Otherwise, punt to default zsh completion.
_fzf_complete_q() {
  local tokens fzfopts
  tokens=(${(z)@})

  # Combination of '-d' and '--with-nth=-1' prunes path from displayed files
  fzfopts="--with-nth=1,2,6.. --header-lines=1 --reverse --exit-0"

  # List of options that take a job id as argument
  if [[ ${tokens[-1]} =~ "-c|-D|-i|-k|-o|-p|-r|-s|-t|-u|-w" ]]; then
    \ts | _fzf_complete "${fzfopts}" "$@"
  elif [[ ${tokens[-1]} == "-U" ]]; then
    # Usage is "-U <id>-<id>"
    # Complete if we've got a blank string or "<id>-"
    if test -z "${prefix}" ; then
      \ts | _fzf_complete_ext -A "-" -l "$@" -o "${fzfopts}" -p "cut -d ' ' -f 1" -q "${prefix}"
    elif [[ ${prefix} =~ "[0-9]+-" ]]; then
      # TODO: Prune first job id from list
      \ts | _fzf_complete_ext -l "$@${prefix}" -o "${fzfopts}" -p "cut -d ' ' -f 1"
    fi
  else
    zle ${fzf_default_completion:-expand-or-complete}
  fi
}

# Extract job id from line of task-spooler output
_fzf_complete_q_post() {
  cut -d ' ' -f 1
}

# Set up job finished handle
ts_handler="${HOME}/bin/ts-handler"
if test -x "${ts_handler}" ; then
  export TS_ONFINISH="${ts_handler}"
fi
