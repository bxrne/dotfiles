#!/bin/bash

options="performance\nbalanced\npower-saver"

chosen=$(echo -e "$options" | wofi --dmenu --no-input --prompt "Power Profile" --width 250 --height 220)

case $chosen in
    "performance")
        powerprofilesctl set performance
        ;;
    "balanced")
        powerprofilesctl set balanced
        ;;
    "power-saver")
        powerprofilesctl set power-saver
        ;;
esac
