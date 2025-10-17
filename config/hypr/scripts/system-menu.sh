#!/bin/bash

options="Shutdown\nReboot\nLock\nLogout\nSuspend"

chosen=$(echo -e "$options" | wofi --dmenu --no-input --prompt "System" --width 250 --height 220)

case $chosen in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Lock")
        hyprlock
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Suspend")
        systemctl suspend
        ;;
esac
