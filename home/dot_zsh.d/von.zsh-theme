#!/bin/zsh
# My asynchronous zsh theme
# Requires zsh-async: https://github.com/mafredri/zsh-async
# Kudos:
#   https://github.com/sindresorhus/pure
#   https://medium.com/@henrebotha/how-to-write-an-asynchronous-zsh-prompt-b53e81720d32
#
# See 'man zshmisc' section "SIMPLE PROMPT ESCAPES"
#
# Note that the "%{...%}" surrounds tell zsh the contained takes up
# zero charcters. Use for escape codes, colors and the like.
# Kudos: http://superuser.com/a/655872

# Configuration {{{ #

setopt promptsubst

# For von_theme_error()
VON_THEME_ERROR_COLOR=%{red}

# Color of line separator
VON_THEME_SEPARATOR_COLOR=%F{245}  # Grey
VON_THEME_SEPARATOR_ERROR_COLOR=%F{red}

# Prompt itself
VON_THEME_PROMPT="❯"

# Color of prompt character in different modes
VON_THEME_PROMPT_VICMD_COLOR=%F{blue}
VON_THEME_PROMPT_VIINS_COLOR=%F{green}

# Color of username and prompt for non-root
VON_THEME_USER_COLOR=%F{green}
VON_THEME_USER_PROMPT_COLOR=%F{white}

# Color of username and prompt for root
VON_THEME_ROOT_COLOR=%F{red}
VON_THEME_ROOT_PROMPT_COLOR=%F{white}

# Color of hostname
VON_THEME_HOSTNAME_COLOR=%F{green}

# Color of working directory
VON_THEME_WORKINGDIR_COLOR=%F{96}  # Plum4
# Color of non-existant working directory
VON_THEME_NE_WORKINGDIR_COLOR=%F{red}

# Color of time
VON_THEME_TIME_COLOR=%F{245}  # Grey54

# Color of history event number
VON_THEME_HISTORY_COLOR=%F{245}  # Grey54

# Color of virtualenv name
VON_THEME_VIRTUALENV_COLOR=%F{cyan}

# Color of SSID name
VON_THEME_SSID_COLOR=%F{149}  # DarkOliveGreen3

# Color of script filename
VON_THEME_SCRIPT_COLOR=%F{yellow}

# Color of desk filename
VON_THEME_DESK_COLOR=%F{cyan}

# Color of prompttag
VON_THEME_TAG_COLOR=%F{green}

# COLOR of svn info
VON_THEME_SVN_COLOR=%F{cyan}

# Color for jobs indication
VON_THEME_JOBS_COLOR=%F{green}

# Color for VI mode indication
VON_THEME_VIMODE_COLOR=%F{green}

# Color for VIFM mode indication
VON_THEME_VIFMMODE_COLOR=%F{cyan}

# Color for Chezmoi directory indication
VON_THEME_CHEZMOI_COLOR=%F{green}
VON_THEME_CHEZMOI_DIRTY_COLOR=%F{red}

# Color of preexec output
VON_THEME_PREEXEC_COLOR=%F{245}  # Grey54

# Color for warnings
VON_THEME_WARNING_COLOR=%F{red}

# Disable prompt modifications by virtualenv.
VIRTUAL_ENV_DISABLE_preprompt=1

# oh-my-zsh git-prompt plugin configuration
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}[git:%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{cyan}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"

ZSH_THEME_GIT_PROMPT_BRANCH=%F{96}  # Plum4, matches working dir on next line
ZSH_THEME_GIT_PROMPT_CONFLICTS="%F{red%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_STAGED="%F{magenta%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%F{green}+"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{red}%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{green}%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{yellow}%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}%{✔%G%}"
ZSH_THEME_GIT_PROMPT_STASHED="%F{blue}%{⚑%G%}"

# Warning when in detached head state
ZSH_DETACHED_HEAD="%F{red}[Detached]%{$reset_color%}"

# Clear RPROMPT after user enters command
setopt transientrprompt

# Escape sequence to tmux next-prompt / previous-prompt can find prompt
TMUX_PROMPT_MARK=$'\e]133;A]\e\\'

# }}} Configuration #

# von_theme_error {{{ #
function von_theme_error() {
  print -P "%{%F{red}%}von_theme_error: ${(q)@}%{$reset_color%}"
}
# }}} von_theme_error #

# von_theme_vcs_job() {{{ #
function von_theme_svn_job() {
    rev=$(svn info 2>/dev/null | sed -ne 's#^Revision: ##p')
    if test -n "${rev}" ; then
        echo -ne "%{$VON_THEME_SVN_COLOR%}(svn:${rev})%{$reset_color%}"
    fi
}

# Return string for whichever version control system is in effect
# for current directory.
function von_theme_vcs_job() {
  local pwd="${1}"
  # Check to make sure current directory exists so we don't generate a bunch
  # of errors if it does not.
  test -d ${pwd} || return 0
  cd "${pwd}"
  _git_prompt=$(git_super_status)  # oh-my-zsh git-prompt-plugin
  if test -n "${_git_prompt}" ; then
      echo -ne "${_git_prompt}"
      # Check for detacted head and warn
      local HEAD="$(git symbolic-ref HEAD 2>/dev/null)"
      if [ -z "$HEAD" ]; then
        echo -ne "${ZSH_DETACHED_HEAD}"
      fi
      return
  fi
  von_theme_svn_job
}
# }}} von_theme_vcs_job() #

# von_theme_ssh_check_job() {{{ #
function von_theme_ssh_check_job() {
  ssh-add -l >& /dev/null
  if test $? -ne 0 ; then
    echo -ne "%{$VON_THEME_WARNING_COLOR%}[No SSH keys]%{$reset_color%}"
  fi
  return 0
}
# }}} von_theme_ssh_check_job() #

# von_theme_check_cwd {{{ #
function von_theme_check_cwd() {
  test -d ${1:-.} || echo -ne "%{$VON_THEME_NE_WORKINGDIR_COLOR%}[cwd]%{$reset_color%}"
  return 0
}
# }}} von_theme_check_cwd #

# von_theme_chezmoi_job() {{{ #
function von_theme_chezmoi_job() {
  if [[ ${1}/ = ${HOME}/.local/share/chezmoi/* ]]; then
    if chezmoi verify ; then
      echo -ne "%{$VON_THEME_CHEZMOI_COLOR%}[chezmoi]%{$reset_color%}"
    else
      echo -ne "%{$VON_THEME_CHEZMOI_DIRTY_COLOR%}[chezmoi]%{$reset_color%}"
    fi
  fi
  return 0
}
# }}} von_theme_chezmoi_job #

# von_theme_virtualenv_job() {{{ #
function von_theme_virtualenv_job() {
  if test -n "${VIRTUAL_ENV}" ; then
    echo -ne "%{$VON_THEME_VIRTUALENV_COLOR%}[VE:`basename "$VIRTUAL_ENV"`]%{$reset_color%}"
  fi
  return 0
}
# }}} von_theme_virtualenv_job() #

# von_theme_script_job() {{{ #
function von_theme_script_job() {
  if test -n "${SCRIPT_FILE}" ; then
    echo -ne "%{$VON_THEME_SCRIPT_COLOR%}[Scripting: ${SCRIPT_FILE}]%{$reset_color%}"
  fi
  return 0
}
# }}} von_theme_script_job() #

# von_theme_maint_job {{{ #
function von_theme_maint_job() {
  # Check if it has been greater than 7 days since we ran
  # 'mysetup.py maint' $MAINT_TIMESTAMP set in maint.zsh
  if test -e ${MAINT_TIMESTAMP} ; then
    if (( `date +%s` - `stat -t %s -f %m ${MAINT_TIMESTAMP}` > 604800 )) ; then
      echo -ne "%{$VON_THEME_WARNING_COLOR%}[Maint]%{$reset_color%}"
    fi
  fi
  return 0
}
# }}} von_theme_maint_job #

# von_theme_background_job {{{ #
# TODO: If there are no background jobs, this causes an extra space between tags
function von_theme_background_job() {
  # Display number of background jobs, if there are any
  echo -ne "%1(j.%{$VON_THEME_JOBS_COLOR%} [Jobs: %j]%{$reset_color%}.)"
  return 0
}
# }}} von_theme_background_job #

# von_theme_desk_job() {{{ #
function von_theme_desk_job() {
    if test -n "${DESK_NAME}" ; then
        echo -ne "%{$VON_THEME_DESK_COLOR%}[desk:${DESK_NAME}]%{$reset_color%}"
    fi
    return 0
}
# }}} von_theme_desk_job() #

# von_theme_tag_job() {{{ #
function von_theme_tag_job() {
    if test -n "${PROMPT_TAG}" ; then
        echo -ne "%{$VON_THEME_TAG_COLOR%}[${PROMPT_TAG}]%{$reset_color%}"
    fi
    return 0
}
# }}} von_theme_tag_job() #

# von_theme_vifm_cd_job {{{ #
function von_theme_vifm_cd_job() {
  test ${#chpwd_functions} -eq 0 && return 0
  # Check if vifm_cd_pwd or vifm_cd_pwd_2 is in chpwd_functions
  # Kudos: https://stackoverflow.com/a/5203740/197789
  if [[ ${chpwd_functions[(i)vifm_cd_pwd]} -le ${#chpwd_functions} ]] ; then
    echo -ne "%{$VON_THEME_VIFMMODE_COLOR%}[VIFM]%{$reset_color%}"
  elif [[ ${chpwd_functions[(i)vifm_cd_pwd_2]} -le ${#chpwd_functions} ]] ; then
    echo -ne "%{$VON_THEME_VIFMMODE_COLOR%}[VIFM2]%{$reset_color%}"
  fi
  return 0
}
# }}} von_theme_vifm_cd_job #

# von_theme_jobs {{{ #
# Jobs to be run synchronously, with results added to RPROMPT
von_theme_jobs=()
von_theme_jobs+=(von_theme_virtualenv_job)
von_theme_jobs+=(von_theme_script_job)
von_theme_jobs+=(von_theme_desk_job)
von_theme_jobs+=(von_theme_tag_job)
von_theme_jobs+=(von_theme_vifm_cd_job)

# }}} von_theme_jobs #

# von_theme_async_jobs {{{ #
# Jobs to be run asynchronously, with results added to RPROMPT
von_theme_async_jobs=()
von_theme_async_jobs+=(von_theme_check_cwd)
von_theme_async_jobs+=(von_theme_vcs_job)
# Not using SSH much these days, so disable this check
# von_theme_async_jobs+=(von_theme_ssh_check_job)
von_theme_async_jobs+=(von_theme_maint_job)
von_theme_async_jobs+=(von_theme_background_job)
von_theme_async_jobs+=(von_theme_chezmoi_job)
# }}} von_theme_async_jobs #

# von_theme_callback() {{{ #
# Callback used by von_theme_worker
# If return code == 0, stdout should have text to add to RPROMPT
# Otherwise, handle as error
von_theme_callback() {
  local job_name=${1}
  local rc=${2}
  local stdout="${3}"
  local executiion_time="${4}"  # floating point
  local stderr="${5}"
  local pending=${6}  # If 1, will get called again immediately, delay prompt update

  case ${rc} in
    0)
      :  # Success
      ;;
    2|3|130)
      # Worker died. See
      # https://github.com/mafredri/zsh-async/issues/42#issuecomment-716782220
      async_stop_worker von_theme_worker
      von_theme_init_worker
      von_theme_start_async_jobs
      return
      ;;
    *)
      von_theme_error "${job_name}:${rc}:${stderr}"
      return
  esac
  rprompt_parts[${job_name}]="${stdout}"
  if test $pending -eq 0 ; then
    von_theme_rebuild_rprompt
    zle reset-prompt
  fi
}
# }}} von_theme_callback() #

# von_theme_rebuild_rprompt() {{{ #
# Merge rprompt_parts into RPROMPT
function von_theme_rebuild_rprompt() {
  # Get non-empty (:#) reprompt values (v)
  local values=${(v)rprompt_parts:#}
  # And joint them with spaces
  RPROMPT=${(j: :)values}
}
# }}} von_theme_rebuild_rprompt() #

# von_theme_run_sync_jobs() {{{ #
function von_theme_run_sync_jobs() {
  for job in ${von_theme_jobs} ; do
    local stdout=$(${job})
    if test $? -eq 0 ; then
      rprompt_parts[${job}]=$(${job})
    fi
  done
}
# }}} von_theme_run_sync_jobs() #

# von_theme_start_async_jobs() {{{ #
function von_theme_start_async_jobs() {
  async_flush_jobs von_theme_worker
  # Guard for non-existing current directory
  if test -d ${PWD} ; then
    for job in ${von_theme_async_jobs} ; do
      async_job von_theme_worker ${job} ${PWD}
    done
  fi
}
# }}} von_theme_start_async_jobs() #

# von_theme_precmd() {{{ #
# Start aysnc jobs to update RPROMPT
function von_theme_precmd() {

  local STATUS=$?
  if test ${STATUS} -ne 0 ; then
    print -P "${VON_THEME_SEPARATOR_ERROR_COLOR}# Status: ${STATUS}${reset_color}"
  fi

  rprompt_parts=()
  von_theme_run_sync_jobs
  von_theme_rebuild_rprompt
  von_theme_start_async_jobs
}
# }}} von_theme_precmd() #

# von_theme_init_worker {{{ #
function von_theme_init_worker() {
  # Start a worker that will report job completion (with notify option)
  # Note all functions passed as jobs must be defined before worker
  # is created: https://github.com/mafredri/zsh-async/issues/17#issuecomment-287108117
  async_start_worker von_theme_worker -n

  # Register our callback function to run when the job completes
  async_register_callback von_theme_worker von_theme_callback
}
# }}} von_theme_init_worker #

# von_theme_init() {{{ #
function von_theme_init() {
  # Make sure zsh-async is installed
  if typeset -f async_init > /dev/null; then
    # Initialize zsh-async
    async_init
    von_theme_init_worker
  else
    von_theme_error "zsh-async not found. Disabling async jobs."
    function von_theme_start_async_jobs() { }
  fi

  zmodload zsh/zle
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd von_theme_precmd

  if [ -n "$TMUX" ]; then
    # We are running in tmux.
    # title.zsh will be setting the window title with hostname and path which
    # is picked up by tmux and displayed.
    PROMPT=$'%{${VON_THEME_PROMPT_COLOR}%}${VON_THEME_PROMPT}%{$reset_color%}%{${TMUX_PROMPT_MARK}%} '
  else
    # We are not running in tmux. Need to display stuff ourselves.
    PROMPT=$'%{${VON_THEME_WORKINGDIR_COLOR}%}%~%{$reset_color%} %{${VON_THEME_PROMPT_COLOR}%}${VON_THEME_PROMPT}%{$reset_color%} '
  fi

  RPROMPT=""

  # Update prompt regularly
  TMOUT=30  # How often SIGALRM is sent when prompt receives no input, in seconds

  # Trap SIGALRM and redraw prompt
  TRAPALRM() {
    von_theme_run_sync_jobs
    von_theme_rebuild_rprompt
    zle reset-prompt
    von_theme_start_async_jobs
  }

  function zle-line-init zle-keymap-select {
    case ${KEYMAP} in
      vicmd) VON_THEME_PROMPT_COLOR=${VON_THEME_PROMPT_VICMD_COLOR} ;;
      viins|main) VON_THEME_PROMPT_COLOR=${VON_THEME_PROMPT_VIINS_COLOR} ;;
    esac
    zle reset-prompt
  }
  zle -N zle-keymap-select
}
# }}} von_theme_init() #

# Display VI mode state {{{ #
# Kudos:
#  https://pthree.org/2009/03/28/add-vim-editing-mode-to-your-zsh-prompt/
#  http://dougblack.io/words/zsh-vi-mode.html

# Show mode in prompt if we are in VI command mode.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    # Double subsitution: "vicmd"->"[cmd]", "main" or "viins" -> ""
    rprompt_parts[vimode]="${${KEYMAP/vicmd/[cmd]}/(main|viins)/}"
    von_theme_rebuild_rprompt
    zle reset-prompt
}

zle -N zle-keymap-select
# }}} Display VI mode state #

# rprompt_parts is an associative array keyed by job_name with its stdout as value
# The values are combined by von_theme_rebuild_rprompt to create RPROMPT
declare -A rprompt_parts

if test -n "${RELOAD_ZSHRC}" ; then
  # We are being reloaded, kill and restart our worker so it picks up any changes
  # in functions and environment.
  async_flush_jobs von_theme_worker
  async_stop_worker von_theme_worker
  von_theme_init_worker
else
  von_theme_init
fi

# vim: foldmethod=marker: #
