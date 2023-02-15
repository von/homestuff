#!/bin/zsh
#
# Mac-specific stuff

if test $(uname) = "Darwin" ; then
  # Fix vim install
  # e.g. if python or lua libraries updated
  # TODO: Make this a maint script with a check
  fix-vim() {
    brew uninstall vim && brew install vim --with-lua --with-python@2
  }

  install-xcode-cli() {
    xcode-select --install
  }

  reinstall-xcode-cli() {
    sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install
  }

  # Given Application name, return identifier (e.g. com.apple.mail)
  # Kudos: https://robservatory.com/easily-see-any-apps-bundle-identifier/
  get-app-id() {
    if test $# -eq 1 ; then
      osascript -e "id of app \"${1}\""
    else
      echo "Usage: $0 <application name>"
      return 1
    fi
  }

  # List all USB devices
  # Kudos: https://apple.stackexchange.com/a/170118/104604
  usb-list() {
    ioreg -p IOUSB -w0
  }

  dns-flush() {
    sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
  }

  wifi-connect() {
    test $# -ne 2 && { echo "Usage: $0 SSID PASSWORD" ; return 1 ; }
    SSID=$1; shift
    PASSWORD=$1; shift
    networksetup -setairportnetwork en0 "${SSID}" "${PASSWORD}"
  }

  # Set my wifi password at the dimension mill, where it is changed every month
  wifi-mill() {
    test $# -ne 1 && { echo "Usage: $0 PASSWORD" ; return 1 ; }
    SSID="The Mill-MEMBERS"
    PASSWORD=$1; shift
    networksetup -setairportnetwork en0 "${SSID}" "${PASSWORD}"
  }
  wifi-mill-guest() {
    test $# -ne 1 && { echo "Usage: $0 PASSWORD" ; return 1 ; }
    SSID="The Mill-GUESTS"
    PASSWORD=$1; shift
    networksetup -setairportnetwork en0 "${SSID}" "${PASSWORD}"
  }
fi
