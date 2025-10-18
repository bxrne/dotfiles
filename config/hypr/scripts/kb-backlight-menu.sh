#!/bin/bash

LED_PATH="/sys/class/leds/:white:kbd_backlight"
MAX_BRIGHTNESS=$(cat ${LED_PATH}/max_brightness)  # 14660

options="Off (0%)\nLow (25%)\nMedium (50%)\nHigh (75%)\nMax (100%)"

chosen=$(echo -e "$options" | wofi --dmenu --hide-search --prompt "Keyboard Backlight" --width 250 --height 180)

case $chosen in
    "Off (0%)")
        echo 0 | sudo tee ${LED_PATH}/brightness > /dev/null
        ;;
    "Low (25%)")
        echo 3665 | sudo tee ${LED_PATH}/brightness > /dev/null
        ;;
    "Medium (50%)")
        echo 7330 | sudo tee ${LED_PATH}/brightness > /dev/null
        ;;
    "High (75%)")
        echo 11000 | sudo tee ${LED_PATH}/brightness > /dev/null
        ;;
    "Max (100%)")
        echo 14660 | sudo tee ${LED_PATH}/brightness > /dev/null
        ;;
esac
