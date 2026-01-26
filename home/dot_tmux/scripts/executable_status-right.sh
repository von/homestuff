#!/bin/bash

function usage ()
{
  echo "Usage :  $0 [options] [--]

    Options:
    -d|debug      Turn on debugging
    -h|help       Display this message
"
}

debug=0

while getopts ":dh" opt
do
  case $opt in
  d|debug    )  debug=1;;
  h|help     )  usage; exit 0   ;;
  * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage; exit 1   ;;
  esac
done
shift $(($OPTIND-1))

if test $debug -eq 1 ; then
  debug() { echo $* ; }
else
  debug() { return ;  }
fi

###################################

status="[$(hostname)"

if=$(echo 'show State:/Network/Global/IPv4' | scutil |  awk '/PrimaryInterface/ {print $3}')
if test -n "${if}"; then
  debug "Interface is ${if}"
  ipaddr=$(ifconfig ${if} | awk '/inet / {print $2}')
  status+="/${ipaddr}"
else
  status+="/No interface"
fi

# Kudos: https://snelson.us/2024/09/determining-a-macs-ssid-like-an-animal/
# As of MacOSX 15.6 this needs 'sudo ipconfig setverbose 1' to have been called
# or it will return "<redacted>"
# Kudos: https://discussions.apple.com/thread/256108303?answerId=261575020022&sortBy=rank#261575020022
ssid=$(ipconfig getsummary $(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}') | awk -F ' SSID : ' '/ SSID : / {print $2}')
if test -n "${ssid}"; then
  status+="/${ssid}"
fi

# Make sure status fits in 40 character limit
if test ${#status} -gt 38; then
  status=${status:0:37}
  status+="…]"  # UTF-8 Ellipse
else
  status+="]"
fi

echo -ne $status
exit 0
