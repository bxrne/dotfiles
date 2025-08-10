#!/bin/bash

fetch() {
  local COLOR="\033[0;34m"
  local RESET="\033[0m"
  local OS=$(uname -s)

  # Info command
  local shell_info=$(basename "$SHELL")
  local host_info=$(hostname)

  # Internal IP
  local ip_info=""
  if [[ "$OS" == "Darwin" ]]; then
    ip_info=$(ipconfig getifaddr en0 2>/dev/null)
    if [[ -z "$ip_info" ]]; then
      ip_info=$(ifconfig en0 2>/dev/null | awk '/inet /{print $2}')
    fi
  elif [[ "$OS" == "Linux" ]]; then
    ip_info=$(ip -4 addr show scope global 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
    if [[ -z "$ip_info" ]]; then
      ip_info=$(hostname -I 2>/dev/null | awk '{print $1}')
    fi
  fi
  if [[ -z "$ip_info" ]]; then
    ip_info="N/A"
  fi

  # External IP with failover
  local external_ip_info=$(curl -s --max-time 1 ifconfig.me 2>/dev/null || echo "Offline")

  # Battery
  local battery_info=""
  if [[ "$OS" == "Darwin" ]]; then
    battery_info=$(pmset -g batt 2>/dev/null | grep -Eo "\d+%.*" | cut -d';' -f1-2 | sed 's/;/ /' | xargs)
  elif [[ "$OS" == "Linux" ]]; then
    if [[ -d /sys/class/power_supply/BAT0 ]]; then
      local capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
      local status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null | tr '[:upper:]' '[:lower:]')
      battery_info="${capacity}% ${status}"
    elif command -v upower >/dev/null 2>&1; then
      battery_info=$(upower -e | grep battery | xargs -I{} upower -i {} | grep -E "percentage|state" | awk '{print $2}' | paste -sd ' ' | sed 's/ /% /')
    fi
  fi
  if [[ -z "$battery_info" ]]; then
    battery_info="N/A"
  fi

  # Info lines with some color variations for jazz
  local LABEL_COLOR="\033[0;35m"  # Magenta for labels
  local lines=(
    "${LABEL_COLOR}shell:${RESET}        ${COLOR}${shell_info}${RESET}"
    "${LABEL_COLOR}host:${RESET}         ${COLOR}${host_info}${RESET}"
    "${LABEL_COLOR}ip:${RESET}           ${COLOR}${ip_info}${RESET}"
    "${LABEL_COLOR}external ip:${RESET}  ${COLOR}${external_ip_info}${RESET}"
    "${LABEL_COLOR}power:${RESET}        ${COLOR}${battery_info}${RESET}"
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

  # Add some jazz with corner styles and top/bottom
  echo
  printf "╭%s╮\n" "$border"
  for line in "${lines[@]}"; do
    local stripped=$(echo -e "$line" | sed 's/\x1B\[[0-9;]*m//g')
    local line_length=${#stripped}
    local right_pad=$((box_width - line_length - pad))
    printf "│%*s" $pad ""
    echo -ne "$line"
    printf "%*s│\n" $right_pad ""
  done
  printf "╰%s╯\n" "$border"
  echo
}

fetch
