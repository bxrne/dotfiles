#!/bin/bash

fetch() {
  clear
  local INFO="\033[0;34m"
  local RESET="\033[0m"

  # Collect the output lines
  local uptime_info=$(uptime | awk '{print $3, $4, $5, $6}' | sed 's/,//')
  local shell_info=$(basename $SHELL)
  local host_info=$(hostname)
  local ip_info=$(ifconfig en0 | grep 'inet ' | awk '{print $2}')
  local external_ip_info=$(curl -s ifconfig.me)

  # Define the content lines with color codes
  local lines=(
    "uptime:        ${INFO}${uptime_info}${RESET}"
    "shell:         ${INFO}${shell_info}${RESET}"
    "host:          ${INFO}${host_info}${RESET}"
    "ip:            ${INFO}${ip_info}${RESET}"
    "external ip:   ${INFO}${external_ip_info}${RESET}"
  )

  # Find the longest line length for box width (accounting for color codes)
  local max_length=0
  for line in "${lines[@]}"; do
    # Remove color codes for length calculation
    clean_line=$(echo "$line" | sed 's/\x1B\[[0-9;]*m//g')
    length=${#clean_line}
    if (( length > max_length )); then
      max_length=$length
    fi
  done

  # Add padding to the content width (2 spaces on each side)
  local padding=2
  local box_width=$((max_length + padding * 2))

  # Create the horizontal border
  local horizontal_border=$(printf '%*s' "$box_width" | tr ' ' '-')

  # Print margin (1 empty line above)
  echo

  # Print top border
  echo "┌${horizontal_border}┐"

  # Print each line with padding, using echo -e to interpret color codes
  for line in "${lines[@]}"; do
    # Remove color codes for length calculation
    clean_line=$(echo "$line" | sed 's/\x1B\[[0-9;]*m//g')
    line_length=${#clean_line}
    # Calculate padding spaces needed on the right
    spaces=$((box_width - line_length))
    printf "│%*s" $padding " "
    echo -ne "$line"
    printf "%*s│\n" $((spaces - padding)) " "
  done

  # Print bottom border
  echo "└${horizontal_border}┘"

  # Print margin (1 empty line below)
  echo
}

fetch
