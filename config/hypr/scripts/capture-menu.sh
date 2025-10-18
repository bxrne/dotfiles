#!/bin/bash

options="[CAP] - Region\n[CAP] - Full\n[CAP] - Window\n[REC] - Region\n[REC] - Stop"

chosen=$(echo -e "$options" | wofi --dmenu --hide-search --prompt "Capture" --width 300 --height 180) 

case $chosen in
    "[CAP] - Region")
        grim -g "$(slurp)" - | wl-copy && notify-send "capture copied to clipboard"
        ;;
    "[CAP] - Full")
        grim - | wl-copy && notify-send "capture copied to clipboard"
        ;;
    "[CAP] - Window")
        hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | wl-copy && notify-send "Window capture copied"
        ;;
    "[REC] - Region")
        geometry=$(slurp)
        wf-recorder -g "$geometry" -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4 &
        notify-send "Recording started"
        ;;
    "[REC] - Stop")
        killall -s SIGINT wf-recorder
        notify-send "Recording stopped"
        ;;
esac
