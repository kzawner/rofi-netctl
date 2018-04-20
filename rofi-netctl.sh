#!/usr/bin/env bash

#
# Flags:
#  - a: Choose only from currently active access points;
#

dev=wlp3s0

profiles=$(find /etc/netctl -maxdepth 1 -type f -printf "%f\n" | cut -d '-' -f "2-")

if [[ "$1" == "-a" ]]; then
  # Get list of active AP, print SSID and signal strength.
  active_ap=$(sudo iw dev $dev scan \
    | grep -e 'SSID' -e 'signal' \
    | xargs -L 2 \
    | gawk '{printf("%-30s %s\n\r", $5, $2, $3)}')

  # Make a regex from profile names, escape it from shell symbols with
  # "printf %q".
  profiles_grep=$(echo $profiles | xargs -l1 printf "%q|" | sed 's/|$//')
  profiles=$(echo "$active_ap" | grep -iE "$profiles_grep")
fi

choice=`echo "$profiles" \
  | rofi -font 'Misc Tamsyn,14' -i -dmenu -p 'network profile'`;

if [ -n "$choice" ]; then
    sudo netctl switch-to $dev-$(echo "$choice" | gawk '{print $1}');
fi
