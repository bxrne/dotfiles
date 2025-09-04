#!/bin/bash

# CPU and RAM Usage Plugin for SketchyBar
# Shows CPU and RAM usage percentages

# Get system-wide CPU usage (0-100%)
CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print int($3)}')

# Get system RAM usage percentage
RAM_INFO=$(vm_stat | grep "Pages active\|Pages wired\|Pages compressed" | awk '{sum += $3} END {print sum}')
TOTAL_PAGES=$(vm_stat | grep "Pages free\|Pages active\|Pages inactive\|Pages speculative\|Pages wired\|Pages compressed" | awk '{sum += $3} END {print sum}')
if [ "$TOTAL_PAGES" -gt 0 ]; then
    RAM_USAGE=$(( (RAM_INFO * 100) / TOTAL_PAGES ))
else
    RAM_USAGE=0
fi

# Set the display
sketchybar --set $NAME label="CPU: ${CPU_USAGE}% | RAM: ${RAM_USAGE}%" icon=""