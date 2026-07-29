# Configuration for ssh
#
# Use gpg-agent for ssh
# Kudos: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
