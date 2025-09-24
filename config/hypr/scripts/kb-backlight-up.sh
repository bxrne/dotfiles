#!/bin/bash

LED_PATH="/sys/class/leds/:white:kbd_backlight"
levels=(0 3665 7330 11000 14660)

current=$(cat ${LED_PATH}/brightness)

for i in "${!levels[@]}"; do
    if [ "${levels[$i]}" -eq "$current" ]; then
        next_index=$((i + 1))
        if [ $next_index -lt ${#levels[@]} ]; then
            echo ${levels[$next_index]} | sudo tee ${LED_PATH}/brightness > /dev/null
        fi
        break
    fi
done