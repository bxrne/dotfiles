#!/bin/bash

options="Extend\nMirror"

chosen=$(echo -e "$options" | wofi --dmenu --hide-search --prompt "Display Mode" --width 250 --height 75)

case $chosen in
    "Extend")
        hyprctl keyword monitor eDP-1,3072x1920@60,0x0,2
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,1920x0,1
        notify-send "Display mode: Extend"
        ;;
    "Mirror")
        hyprctl keyword monitor eDP-1,3072x1920@60,0x0,2
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,0x0,1
        notify-send "Display mode: Mirror"
        ;;
esac
