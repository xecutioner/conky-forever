#!/bin/bash

status=`cat /sys/class/power_supply/BAT0/status`
tmp=`cat /tmp/acpower`
if [ "$status" == "$tmp" ]; then
    exit
fi

if [ "$status" == "Discharging" ]; then
    notify-send "AC" "UnPlugged" -i /usr/share/icons/HighContrast/256x256/status/battery-caution.png
    # xset b 
    # echo -e "\a"
    # sleep 2
    # xset -b
else
    notify-send "AC" "Plugged" -i /usr/share/icons/HighContrast/256x256/apps/gnome-power-manager.png
fi

echo "$status" > /tmp/acpower
