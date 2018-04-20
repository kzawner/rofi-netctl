#!/usr/bin/env bash

#
# Flags:
#  - a: Choose only from currently active access points;
#

dev=wlp3s0

profiles=$(find /etc/netctl -maxdepth 1 -type f -printf "%f\n")

if [[ "$1" == "-a" ]]; then
  active_ap=$(sudo iw dev $dev scan | grep SSID: | gawk '{print $2}' \
        | xargs -l1 printf "%q|" | sed 's/|$//')

  profiles=$(echo "$profiles" | grep -E $active_ap)
fi

choice=`echo "$profiles" | rofi -font 'Misc Tamsyn,14' -i -dmenu -p 'network profile'`;

if [ -n "$choice" ]; then
    sudo netctl switch-to $choice;
fi
