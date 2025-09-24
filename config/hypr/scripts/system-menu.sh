#!/bin/bash

options="⏻ Shutdown\n⟳ Reboot\n Lock\n Logout\n⏾ Suspend"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "System" --width 250 --height 220)

case $chosen in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "⟳ Reboot")
        systemctl reboot
        ;;
    " Lock")
        hyprlock
        ;;
    " Logout")
        hyprctl dispatch exit
        ;;
    "⏾ Suspend")
        systemctl suspend
        ;;
esac
