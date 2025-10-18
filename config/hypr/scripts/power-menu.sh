#!/bin/bash

options="performance\nbalanced\npower-saver"

chosen=$(echo -e "$options" | wofi --dmenu --hide-search --prompt "Power Profile" --width 250 --height 100)

case $chosen in
    "performance")
        powerprofilesctl set performance
        ;;
    "balanced")
        powerprofilesctl set balanced
        ;;
    "power saver")
        powerprofilesctl set power-saver
        ;;
esac
