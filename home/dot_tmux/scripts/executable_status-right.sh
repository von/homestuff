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
debug "Interface is ${if}"
ipaddr=$(ifconfig ${if} | awk '/inet / {print $2}')
status+="/${ipaddr}"

ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
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
