#!/bin/bash

options="📷 Screenshot - Region\n🖼️ Screenshot - Full\n🪟 Screenshot - Window\n🎥 Record - Region\n⏹️ Stop Recording"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Capture" --width 300 --height 250)

case $chosen in
    "📷 Screenshot - Region")
        grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot copied to clipboard"
        ;;
    "🖼️ Screenshot - Full")
        grim - | wl-copy && notify-send "Screenshot copied to clipboard"
        ;;
    "🪟 Screenshot - Window")
        hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | wl-copy && notify-send "Window screenshot copied"
        ;;
    "🎥 Record - Region")
        geometry=$(slurp)
        wf-recorder -g "$geometry" -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4 &
        notify-send "Recording started"
        ;;
    "⏹️ Stop Recording")
        killall -s SIGINT wf-recorder
        notify-send "Recording stopped"
        ;;
esac
