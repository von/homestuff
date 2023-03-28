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
  #
  # For a list of Apple applications identifiers:
  # https://support.apple.com/guide/deployment/bundle-ids-for-native-ios-and-ipados-apps-depece748c41/web
  #
  # Can also use mdls, e.g.:
  # mdls -name kMDItemCFBundleIdentifier -r <path to application>
  get-app-id() {
    if test $# -eq 1 ; then
      osascript -e "id of app \"${1}\""
    else
      echo "Usage: $0 <application name>"
      return 1
    fi
  }

  # Get a file's Uniform Type Identifier (uti)
  # For a list of uti:
  # https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
  get-app-uti() {
    if test $# -ne 1 ; then
      echo "Usage: $0 <path>"
      return 1
    fi
    mdls -name kMDItemContentType ${(q)1}
  }

  # Given an extension, get the default app
  # Uses 'duti' installed via Homebrew
  # Kudos: https://superuser.com/a/1092184/128341
  get-default-app() {
    if test $# -ne 1 ; then
      echo "Usage: $0 <suffix or uti>"
      return 1
    fi
    duti -x ${1}
  }

  set-default-app() {
    if test $# -ne 2 ; then
      echo "Usage: $0 <app-id> <suffix or uti>"
      return 1
    fi
    duti -s ${1} ${2} all
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
