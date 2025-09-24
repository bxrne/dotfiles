#!/bin/bash

LED_PATH="/sys/class/leds/:white:kbd_backlight"
levels=(0 3665 7330 11000 14660)

current=$(cat ${LED_PATH}/brightness)

for i in "${!levels[@]}"; do
    if [ "${levels[$i]}" -eq "$current" ]; then
        prev_index=$((i - 1))
        if [ $prev_index -ge 0 ]; then
            echo ${levels[$prev_index]} | sudo tee ${LED_PATH}/brightness > /dev/null
        fi
        break
    fi
done