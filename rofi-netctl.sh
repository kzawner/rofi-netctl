#!/usr/bin/env bash

choice=`find /etc/netctl -maxdepth 1 -type f -printf "%f\n" \
        | rofi -font 'Misc Tamsyn,14' -i -dmenu`;
if [ -n "$choice" ]; then
    gksudo netctl switch-to $choice;
fi
