#!/bin/bash

fetch() {
  local COLOR="\033[0;34m"
  local RESET="\033[0m"

  # Info command
  local shell_info=$(basename "$SHELL")
  local host_info=$(hostname)
  local ip_info=$(ifconfig en0 2>/dev/null | awk '/inet /{print $2}')
  local external_ip_info=$(curl -s --max-time 1 ifconfig.me)

  # Battery
  local battery_info=$(pmset -g batt | grep -Eo '[0-9]+%.*' | cut -d ';' -f1)

  # Info lines
  local lines=(
    "shell:        ${COLOR}${shell_info}${RESET}"
    "host:         ${COLOR}${host_info}${RESET}"
    "ip:           ${COLOR}${ip_info}${RESET}"
    "external ip:  ${COLOR}${external_ip_info}${RESET}"
    "power:        ${COLOR}${battery_info}${RESET}"
  )

  # Calculate max visible length
  local max_length=0
  for line in "${lines[@]}"; do
    local stripped=$(echo -e "$line" | sed 's/\x1B\[[0-9;]*m//g')
    (( ${#stripped} > max_length )) && max_length=${#stripped}
  done

  local pad=2
  local content_width=$((max_length))
  local box_width=$((content_width + pad * 2))
  local border=$(printf '─%.0s' $(seq 1 "$box_width"))

  echo
  printf "┌%s┐\n" "$border"
  for line in "${lines[@]}"; do
    local stripped=$(echo -e "$line" | sed 's/\x1B\[[0-9;]*m//g')
    local line_length=${#stripped}
    local right_pad=$((box_width - line_length - pad))
    printf "│%*s" $pad ""
    echo -ne "$line"
    printf "%*s│\n" $right_pad ""
  done
  printf "└%s┘\n" "$border"
  echo
}

fetch

