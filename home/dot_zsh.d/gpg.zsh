# Configuration and support for gpg

# Kudos: https://askubuntu.com/a/558158/80562
gpg-agent-clear()
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
