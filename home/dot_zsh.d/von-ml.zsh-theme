#!/bin/zsh
#
# Von's multiple-line prompt theme
#
# Derived from the mortalscumbag theme.
#
# Note that the "%{...%}" surrounds tell zsh the contained takes up
# zero charcters. Use for escape codes, colors and the like.
# Kudos: http://superuser.com/a/655872

######################################################################
# Configuration

# Color of line separator
VON_THEME_SEPARATOR_COLOR=%F{245}  # Grey
VON_THEME_SEPARATOR_ERROR_COLOR=%F{red}

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

# COLOR of svn info
VON_THEME_SVN_COLOR=%F{cyan}

# Color for jobs indication
VON_THEME_JOBS_COLOR=%F{green}

# Color for VI mode indication
VON_THEME_VIMODE_COLOR=%F{green}

# Color for VIFM mode indication
VON_THEME_VIFMMODE_COLOR=%F{cyan}

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

######################################################################
# VCS functions

function my_svn_prompt() {
    rev=$(svn info 2>/dev/null | sed -ne 's#^Revision: ##p')
    if test -n "${rev}" ; then
        echo -ne "%{$VON_THEME_SVN_COLOR%}(svn:${rev})%{$reset_color%}"
    fi
}

# Return string for whichever version control system is in effect
# for current directory.
# TODO: Add stash count, perhaps with "≡" character
function my_vcs_prompt() {
    # Check to make sure current directory exists so we don't generate a bunch
    # of errors if it does not.
    test -d ${PWD} || return
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
    my_svn_prompt
}

######################################################################
# Miscellaneous functions

function my_workingdir_prompt() {
    if test -d "${PWD}" ; then
        echo -ne "%{$VON_THEME_WORKINGDIR_COLOR%}%~%{$reset_color%}"
    else
        echo -ne "%{$VON_THEME_NE_WORKINGDIR_COLOR%}${PWD}%{$reset_color%}"
    fi
}

# Kudos: http://stackoverflow.com/a/4481019/197789
function my_ssid_prompt() {
    _ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
    if test -n "${_ssid}"; then
        echo -ne " %{$VON_THEME_SSID_COLOR%}[SSID: ${_ssid}]%{$reset_color%}"
    fi
}

function my_virtualenv_prompt() {
    if test -n "${VIRTUAL_ENV}" ; then
        echo -ne "%{$VON_THEME_VIRTUALENV_COLOR%}[VE:`basename "$VIRTUAL_ENV"`]%{$reset_color%}"
    fi
}

function my_script_prompt() {
    if test -n "${SCRIPT_FILE}" ; then
        echo -ne "%{$VON_THEME_SCRIPT_COLOR%}[Scripting: ${SCRIPT_FILE}]%{$reset_color%}"
    fi
}

function my_desk_prompt() {
    if test -n "${DESK_NAME}" ; then
        echo -ne "%{$VON_THEME_DESK_COLOR%}[desk:${DESK_NAME}]%{$reset_color%}"
    fi
}

function my_ssh_key_check() {
  ssh-add -l >& /dev/null
  if test $? -ne 0 ; then
    echo -ne "%{$VON_THEME_WARNING_COLOR%}[No SSH keys]%{$reset_color%}"
  fi
}

function my_maint_check() {
  # Check if it has been greater than 7 days since we ran
  # 'mysetup.py maint' $MAINT_TIMESTAMP set in maint.zsh
  if test -e ${MAINT_TIMESTAMP} ; then
    if test -n "$(find ${MAINT_TIMESTAMP} -mtime +7d)" ; then
      echo -ne "%{$VON_THEME_WARNING_COLOR%}[Maint]%{$reset_color%}"
    fi
  fi
}

function my_background_jobs() {
  # Display number of background jobs, if there are any
  echo -ne "%1(j.%{$VON_THEME_JOBS_COLOR%}[Jobs: %j]%{$reset_color%}.)"
}

function my_vifm_cd_check() {
  test ${#chpwd_functions} -eq 0 && return
  # Check if vifm_cd_pwd or vifm_cd_pwd_2 is in chpwd_functions
  # Kudos: https://stackoverflow.com/a/5203740/197789
  if [[ ${chpwd_functions[(i)vifm_cd_pwd]} -le ${#chpwd_functions} ]] ; then
    echo -ne "%{$VON_THEME_VIFMMODE_COLOR%}[VIFM]%{$reset_color%}"
  elif [[ ${chpwd_functions[(i)vifm_cd_pwd_2]} -le ${#chpwd_functions} ]] ; then
    echo -ne "%{$VON_THEME_VIFMMODE_COLOR%}[VIFM2]%{$reset_color%}"
  fi
}

function center_message() {
  # Kudos: http://superuser.com/a/846133/128341
  local MSG=${1:-}
  local LFILL=$(( (${COLUMNS}+1) / 2))  # +1 adjusts for odd widths
  local RFILL=$(( ${COLUMNS} / 2))
  local SEP=$'\u2550'
  # Following steps only way I've figured out how to do unicode
  local M="\${(%l:${LFILL}::${SEP}:r:${RFILL}::${SEP}:)MSG}"
  echo ${(e)M}
}

######################################################################
# Display VI mode state
#
# Kudos:
#  https://pthree.org/2009/03/28/add-vim-editing-mode-to-your-zsh-prompt/
#  http://dougblack.io/words/zsh-vi-mode.html

# Show mode in prompt if we are in VI command mode.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    # Double subsitution: "vicmd"->"[cmd]", "main" or "viins" -> ""
    PROMPT_VIMODE="${${KEYMAP/vicmd/[cmd]}/(main|viins)/}"
    zle reset-prompt
}

zle -N zle-keymap-select

# zle-line-finish is executed when we finished reading a line
# We use it to clear our VIMODE prompt.
function zle-line-finish {
    PROMPT_VIMODE=""
}

zle -N zle-line-finish

######################################################################
# Prompt
#
# We use a single-line prompt and then use a precmd to print the first
# couple of lines since zsh seems to have problems with multiline prompts
# if one does tab completion.
#
# See 'man zshmisc' section "SIMPLE PROMPT ESCAPES"

# Use non-breaking space so tmux can find prompt.
# See https://unix.stackexchange.com/a/353415/29832
nbsp=" "

# Prompt character, red # if root, white % otherwise
PROMPT=$'%(!.%{$VON_THEME_ROOT_PROMPT_COLOR%}#.%{$VON_THEME_USER_PROMPT_COLOR%}%%)%{$reset_color%}${nbsp}'

######################################################################
# Right-hand side prompt

# Show VI mode
RPROMPT=$'$(prompt_tags)%{$VON_THEME_VIMODE_COLOR%}$PROMPT_VIMODE%{$reset_color%}'

# Clear RPROMPT after user enters command
setopt transientrprompt

######################################################################
# prompt_tags()

prompt_tag_functions=()
prompt_tag_functions+=(my_vcs_prompt)
prompt_tag_functions+=(my_virtualenv_prompt)
prompt_tag_functions+=(my_desk_prompt)
prompt_tag_functions+=(my_script_prompt)
prompt_tag_functions+=(my_ssh_key_check)
prompt_tag_functions+=(my_maint_check)
prompt_tag_functions+=(my_vifm_cd_check)
prompt_tag_functions+=(my_background_jobs)

prompt_tags() {
  tags=""
  for f in $prompt_tag_functions ; do
    tag="$(${f})"
    if test -n "${tag}" ; then
      tags+=" ${tag}"
    fi
  done
  echo -ne "${tags}"
}

######################################################################
# prompt_separator

prompt_separator=""

# If we are not running in tmux, add extra line with context
# If we are running in tmux, tmux shows this in the pane status
#   See ./title.zsh
if test -z "${TMUX}" ; then
  # Username, red if root, green otherwise
  prompt_separator+=$'%(!.%{$VON_THEME_ROOT_COLOR%}.%{$VON_THEME_USER_COLOR%})%n%{$reset_color%}'

  # Hostname (first part)
  prompt_separator+=$'@%{$VON_THEME_HOSTNAME_COLOR%}%m%{$reset_color%}'

  # Working directory
  prompt_separator+=$': $(my_workingdir_prompt)'
fi

print_prompt_separator() {
  local STATUS=$?
  if test ${STATUS} -ne 0 ; then
    print -P "${VON_THEME_SEPARATOR_ERROR_COLOR}# Status: ${STATUS}${reset_color}"
  fi

  if test -n "${prompt_separator}" ; then
    # 'print -P' does prompt escape expansion
    print -P ${prompt_separator}
  fi
}

# Add print_prompt_separator to precmd_functions if not already present
# Kudos: https://stackoverflow.com/a/5203740/197789
if [[ ${precmd_functions[(i)print_prompt_separator]} -gt ${#precmd_functions} ]] ; then
  precmd_functions+=(print_prompt_separator)
fi

######################################################################
# Update prompt every 30 seconds
# Kudos: https://stackoverflow.com/a/17915260/197789

# Trap SIGALRM and redraw prompt
TRAPALRM() {
    zle reset-prompt
}

TMOUT=30  # How often SIGALRM is sent when prompt receives no input, in seconds
