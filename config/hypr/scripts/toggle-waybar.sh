#!/bin/bash

# Toggle waybar visibility
if pgrep -x "waybar" > /dev/null; then
    pkill waybar
else
    waybar &
fi