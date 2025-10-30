#!/bin/bash

is_hidden=false

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    if [[ $line == fullscreen* ]]; then
        count=$(hyprctl clients | grep -c "fullscreen: true")
        if [ $count -gt 0 ] && [ "$is_hidden" = false ]; then
            pkill -USR1 waybar
            is_hidden=true
        elif [ $count -eq 0 ] && [ "$is_hidden" = true ]; then
            pkill -USR1 waybar
            is_hidden=false
        fi
    fi
done