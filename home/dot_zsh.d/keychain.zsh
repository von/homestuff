#
# Run keychain if present
# http://www.funtoo.org/wiki/Keychain

# GPGTools seems to create ~/.gpg-agent-info instead of
# setting GPG_AGENT_INFO
# XXX Is GPG_AGENT_INFO even in use any more?
if test -z "${GPG_AGENT_INFO}" -a -r ${HOME}/.gpg-agent-info ; then
  source ${HOME}/.gpg-agent-info
  export GPG_AGENT_INFO
fi

if test ${USE_GPG_AGENT_FOR_SSH:-0} -eq 1 ; then
  # Configure SSH to use gpg-agent (per gpg man page)
  unset SSH_AGENT_PID
  # This handles us being a subshell of gpg-agent
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi

# Homebrew installs gpg-agent as keg not linked to /usr/local/bin
append PATH $(brew --prefix)/opt/gpg-agent/bin

ssh_key="${HOME}/ssh-key/id_rsa"

if (( $+commands[keychain] )) ; then
    # We have keychain installed
    export KEYCHAIN_ARGS

    if test ${USE_GPG_AGENT_FOR_SSH:-0} -eq 1 ; then
      KEYCHAIN_ARGS+=" --ssh-spawn-gpg"
    fi

    if test -n "${SSH_CLIENT}" ; then
        # Remote connection, inherit forwarded agent
        KEYCHAIN_ARGS+=" --ssh-allow-forwarded"
    fi

    # cd to /tmp in case current directory doesn't exist
    # The '=' modifier causes zsh to do word splitting and not quote expansion
    eval `cd /tmp && keychain --eval ${=KEYCHAIN_ARGS} --quiet`

    keychain_reload() {
      # -k all: gpg-agent needs to be restarted to detect Yubikey at times
      echo "Restarting agents: ${KEYCHAIN_AGENTS}"
      keychain -k all --quiet ${=KEYCHAIN_ARGS}
      eval `keychain --eval ${=KEYCHAIN_ARGS}`

      test -z "$GPG_AGENT_INFO" && echo "Warning: GPG_AGENT_INFO not set"
      if test ${USE_GPG_AGENT_FOR_SSH:-0} -eq 1 ; then
        echo "Keys held by agent:"
        keychain -l
      else
        test -z "$SSH_AGENT_PID" && echo "Warning: SSH_AGENT_PID not set"

        # Add my default key if not are loaded
        echo "SSH Keys held by agent:"
        ssh-add -l || ssh-add ~/ssh-key/id_rsa
      fi

      # Load into GUI environment on OSX
      if (( $+commands[launchctl] )) ; then
        if test -n "$GPG_AGENT_INFO" ; then
          echo "Loading GPG_AGENT_INFO into launchctl"
          launchctl setenv GPG_AGENT_INFO $GPG_AGENT_INFO
        fi
        if test -n "$SSH_AGENT_PID" ; then
          echo "Loading SSH_AGENT_PID into launchctl"
          launchctl setenv SSH_AGENT_PID $SSH_AGENT_PID
        fi
      fi

      while test $# -gt 0 ; do
        OPTARG=$1; shift
        case $OPTARG in
          -A) echo "Adding ${ssh_key}" ; ssh-add "${ssh_key}" ;;
          *) echo "Unrecognized argument: $OPTARG" ;;
        esac
      done

    }
  alias kr=keychain_reload
fi
