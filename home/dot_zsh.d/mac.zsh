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

  # Kudos on Mac DNS CLI:
  # https://www.kittell.net/code/mac-osx-terminal-change-dns/
  # https://superuser.com/a/86188/128341
  # https://superuser.com/a/86245/128341
  # https://superuser.com/a/1081501/128341
  # scutil and networksetup and both interfaces to making changes.
  # scutil is emphemeral while networksetup is permanent.

  # Flush DNS cache
  dns-flush() {
    sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
  }

  # Show active DNS servers
  # XXX 'scutil --dns' will show DNS servers not listed in the following
  dns-show-servers() {
    echo "System-wide DNS servers (from scutil):"
    # The uniq eliminates duplicate scoped servers
    scutil --dns | grep nameserver | uniq

    echo "Service-specific DNS servers"
    # Use tail to skip first line which is a header
    local services=$(networksetup -listallnetworkservices | tail -n +2)
    # Use (f) modifier to split on newline
    for service in ${(f)services} ; do
      echo "DNS servers for ${service}:"
      networksetup -getdnsservers "${service}"
    done
  }

  # Clear any DNS servers.
  dns-clear-servers() {
    # Clear subkeys in scutil
    local subkeys=$(echo "list" | scutil | grep -e "State:/Network/Service/.*/DNS" | cut -w -f 5)
    for subkey in ${subkeys} ; do
      echo "Clearing ${subkey}"
      echo "remove ${subkey}" | sudo scutil
    done

    # Use tail to skip first line which is a header
    local services=$(networksetup -listallnetworkservices | tail -n +2)
    # Use (f) modifier to split on newline
    for service in ${(f)services} ; do
      echo "DNS servers for ${service}:"
      sudo networksetup -setdnsservers "${service}" empty
    done
  }

  # Use the Google public DNS servers
  dns-use-google-servers() {
    networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
  }

  # Do/re-do DHCP
  # Kudos:
  # https://apple.stackexchange.com/a/17429/104604
  # https://superuser.com/a/627581/128341
  dhcp() {
    local if=$(route -n get 0.0.0.0 2>/dev/null | awk '/interface: / {print $2}')
    test -z "${if}" && if="en0"
    echo "Doing DHCP on ${if}"
    sudo ipconfig set ${if} BOOTP
    sudo ipconfig set ${if} DHCP
  }

  # Renew my DHCP lease
  # Kudos:
  # https://apple.stackexchange.com/a/76606/104604
  # https://superuser.com/a/627581/128341
  dhcp-renew() {
    local if=$(route -n get 0.0.0.0 2>/dev/null | awk '/interface: / {print $2}')
    test -z "${if}" && if="en0"
    echo "Renewing DHCP for ${if}"
    echo "add State:/Network/Interface/${if}/RefreshConfiguration temporary" | sudo scutil
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
