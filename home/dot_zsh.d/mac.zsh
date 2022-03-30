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
fi
