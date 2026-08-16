# Configuration and support for gpg
# https://www.gnupg.org/documentation/manuals/gnupg/index.html

# Note we use gpg-agent to access my yubi-key and to provide ssh key access
# ~/.gnupg/gpg-agent.conf should have 'enable-ssh-support'
# See ssh.zsh
# See https://github.com/drduh/yubikey-guide

# Per man page
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

gpg-agent-check()
{
  gpg-connect-agent /bye
}

gpg-agent-kill()
{
  gpgconf --kill gpg-agent
}

gpg-check-yubikey()
{
  gpg --card-status
}

# Kudos: https://askubuntu.com/a/558158/80562
gpg-agent-reload()
{
  echo RELOADAGENT | gpg-connect-agent
}

# Test we can encrypt/decrypt to given GPG id
gpg-test()
{
  test $# -eq 1 || { echo "Usage: $0 <id>" ; return 1 ; }
  local id=$1; shift
  gpg --list-keys "${id}" || return 1
  echo "Testing encryption..."
  echo "Hello world" | gpg -a --encrypt -r "${id}" > /dev/null || return $?
  echo "Testing decryption (may be prompted to decrypt key)..."
  echo "Hello world" | gpg -a --encrypt -r "${id}" | gpg -a --decrypt
  return $?
}

# Make sure gpg-agent is running
# Needed because it is acting as our ssh-agent and it needs to be manually
# started in order to do so.
gpg-agent-check
