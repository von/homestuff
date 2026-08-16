# Configuration for yubikey
#
# I use gpg-agent to access my yubikey. gpg-agent also makes my yubikey available
# to ssh by acting like an ssh-agent.
#
# Kudos:
# https://github.com/drduh/yubikey-guide
#
# Related configuration:
# gpg.zsh
# ssh.zsh
# ../private_dot_gnupg/gpg-agent.conf.tmpl

yubikey-test()
{
  echo "Checking that gpg sees yubikey..."
  # Note space in sed argument to trim whitespace after colon
  local card_id=$(gpg --card-status | grep "Application ID" | sed 's/.*\: //')
  if test $? -ne 0 ; then
    echo "yubikey not found by gpg"
    return 1
  fi
  echo "Card Id: $card_id"

  echo "Checking that gpg sees yubikey secret key..."
  gpg -K | grep $card_id > /dev/null
  if test $? -ne 0 ; then
    echo "yubikey not found in gpg secret keys"
    return 1
  fi

  echo "Checking ssh can see card..."
  ssh-add -l | grep $card_id > /dev/null
  if test $? -ne 0 ; then
    echo "ssh does not see yubikey"
    return 1
  fi

  echo "Success"
  return 0
}
