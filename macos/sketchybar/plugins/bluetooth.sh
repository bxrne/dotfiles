#!/bin/bash

# Bluetooth Device Count Plugin for SketchyBar
# Shows the number of connected Bluetooth devices

# Get connected Bluetooth devices count
BT_COUNT=$(system_profiler SPBluetoothDataType | sed -n '/Connected:/,/Not Connected:/p' | grep -c "Address:")

# Set the display
if [ "$BT_COUNT" -gt 0 ]; then
    sketchybar --set $NAME label="$BT_COUNT" icon="" label.color=0xff00aaff
else
    sketchybar --set $NAME label="0" icon="" label.color=0xff666666
fi