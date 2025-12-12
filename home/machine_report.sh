#!/bin/bash
# TR-100 Machine Report (Arch Linux Compatible) - Tokyo Storm Edition
# Refactored for Arch Linux compatibility
# Original Copyright © 2024, U.S. Graphics, LLC. BSD-3-Clause License.

# Dependencies: iproute2, gawk, coreutils, util-linux, procps-ng, bc

# Parse command line arguments
USE_COLORS=false
while getopts "c" opt; do
    case $opt in
        c) USE_COLORS=true ;;
        *) echo "Usage: $0 [-c]" >&2
           echo "  -c    Enable Tokyo Storm colors (for interactive terminals)" >&2
           exit 1 ;;
    esac
done

# Tokyo Storm Theme Colors (Basic ANSI fallback for compatibility)
if [ "$USE_COLORS" = true ] && [ -t 1 ] && [ "$TERM" != "dumb" ]; then
    COLOR_RESET="\033[0m"
    COLOR_FG="\033[38;5;147m"          # Light blue (close to #c0caf5)
    COLOR_TITLE="\033[38;5;75m"        # Blue (close to #7aa2f7)
    COLOR_ACCENT="\033[38;5;141m"       # Purple (close to #bb9af7)
    COLOR_HIGHLIGHT="\033[38;5;208m"    # Orange (close to #ff9e64)
    COLOR_BORDER="\033[38;5;60m"        # Dark blue (close to #414868)
    COLOR_BAR_USED="\033[38;5;75m"       # Blue for used bars
    COLOR_BAR_FREE="\033[38;5;60m"       # Dark blue for free bars
else
    # No color support - use empty strings
    COLOR_RESET=""
    COLOR_FG=""
    COLOR_TITLE=""
    COLOR_ACCENT=""
    COLOR_HIGHLIGHT=""
    COLOR_BORDER=""
    COLOR_BAR_USED=""
    COLOR_BAR_FREE=""
fi

# Global variables
MIN_NAME_LEN=5
MAX_NAME_LEN=13

MIN_DATA_LEN=20
MAX_DATA_LEN=45

BORDERS_AND_PADDING=7

# Basic configuration
report_title="MACHINE REPORT"
last_login_ip_present=0
zfs_present=0
zfs_filesystem="zroot/ROOT/os"

# Utilities
max_length() {
    local max_len=0
    local len

    for str in "$@"; do
        len=${#str}
        if (( len > max_len )); then
            max_len=$len
        fi
    done

    if [ $max_len -lt $MAX_DATA_LEN ]; then
        printf '%s' "$max_len"
    else
        printf '%s' "$MAX_DATA_LEN"
    fi
}

set_current_len() {
    CURRENT_LEN=$(max_length                                         \
        "$report_title"                                              \
        "$os_name"                                                   \
        "$os_kernel"                                                 \
        "$net_hostname"                                              \
        "$net_machine_ip"                                            \
        "$net_client_ip"                                             \
        "$net_current_user"                                          \
        "$cpu_model"                                                 \
        "$cpu_cores_logical Logical CPU(s)"                          \
        "$cpu_hypervisor"                                            \
        "$cpu_freq GHz"                                              \
        "$cpu_1min_bar_graph"                                        \
        "$cpu_5min_bar_graph"                                        \
        "$cpu_15min_bar_graph"                                       \
        "$zfs_used_gb/$zfs_available_gb GB [$disk_percent%]"         \
        "$disk_bar_graph"                                            \
        "$zfs_health"                                                \
        "$root_used_gb/$root_total_gb GB [$disk_percent%]"           \
        "${mem_used_gb}/${mem_total_gb} GiB [${mem_percent}%]"       \
        "${mem_bar_graph}"                                           \
        "$last_login_time"                                           \
        "$last_login_ip"                                             \
        "$last_login_ip"                                             \
        "$sys_uptime"                                                \
        "$os_age_text" \
    )
}

PRINT_HEADER() {
    local length=$((CURRENT_LEN+MAX_NAME_LEN+BORDERS_AND_PADDING))

    local top="${COLOR_BORDER}┌"
    local bottom="${COLOR_BORDER}├"
    for (( i = 0; i < length - 2; i++ )); do
        top+="┬"
        bottom+="┴"
    done
    top+="┐${COLOR_RESET}"
    bottom+="┤${COLOR_RESET}"

    printf '%s\n' "$top"
    printf '%s\n' "$bottom"
}

PRINT_CENTERED_DATA() {
    local max_len=$((CURRENT_LEN+MAX_NAME_LEN-BORDERS_AND_PADDING))
    local text="$1"
    local total_width=$((max_len + 12))

    local text_len=${#text}
    local padding_left=$(( (total_width - text_len) / 2 ))
    local padding_right=$(( total_width - text_len - padding_left ))

    if [[ "$text" == *"MACHINE REPORT"* ]]; then
        printf "${COLOR_BORDER}│${COLOR_RESET}%${padding_left}s${COLOR_TITLE}%s${COLOR_RESET}%${padding_right}s${COLOR_BORDER}│${COLOR_RESET}\n" "" "$text" ""
    elif [[ "$text" == *"TR-100"* ]]; then
        printf "${COLOR_BORDER}│${COLOR_RESET}%${padding_left}s${COLOR_ACCENT}%s${COLOR_RESET}%${padding_right}s${COLOR_BORDER}│${COLOR_RESET}\n" "" "$text" ""
    else
        printf "${COLOR_BORDER}│${COLOR_RESET}%${padding_left}s${COLOR_TITLE}%s${COLOR_RESET}%${padding_right}s${COLOR_BORDER}│${COLOR_RESET}\n" "" "$text" ""
    fi
}

PRINT_DIVIDER() {
    local side="$1"
    case "$side" in
        "top")
            local left_symbol="${COLOR_BORDER}├"
            local middle_symbol="${COLOR_BORDER}┬"
            local right_symbol="${COLOR_BORDER}┤${COLOR_RESET}"
            ;;
        "bottom")
            local left_symbol="${COLOR_BORDER}└"
            local middle_symbol="${COLOR_BORDER}┴"
            local right_symbol="${COLOR_BORDER}┘${COLOR_RESET}"
            ;;
        *)
            local left_symbol="${COLOR_BORDER}├"
            local middle_symbol="${COLOR_BORDER}┼"
            local right_symbol="${COLOR_BORDER}┤${COLOR_RESET}"
    esac

    local length=$((CURRENT_LEN+MAX_NAME_LEN+BORDERS_AND_PADDING))
    local divider="$left_symbol"
    for (( i = 0; i < length - 3; i++ )); do
        divider+="${COLOR_BORDER}─"
        if [ "$i" -eq 14 ]; then
            divider+="$middle_symbol"
        fi
    done
    divider+="$right_symbol"
    printf '%s\n' "$divider"
}

PRINT_DATA() {
    local name="$1"
    local data="$2"
    local max_data_len=$CURRENT_LEN

    local name_len=${#name}
    if (( name_len < MIN_NAME_LEN )); then
        name=$(printf "%-${MIN_NAME_LEN}s" "$name")
    elif (( name_len > MAX_NAME_LEN )); then
        name=$(echo "$name" | cut -c 1-$((MAX_NAME_LEN-3)))...
    else
        name=$(printf "%-${MAX_NAME_LEN}s" "$name")
    fi

    # For Unicode characters, we need to handle them specially
    # Check if data contains Unicode block characters (bar graphs)
    if [[ "$data" == *"█"* ]] || [[ "$data" == *"░"* ]]; then
        # Bar graphs are exactly max_data_len visual characters, don't truncate
        data=$(printf "%-${max_data_len}s" "$data")
    else
        local data_len=${#data}
        if (( data_len > MAX_DATA_LEN )); then
            data=$(echo "$data" | cut -c 1-$((MAX_DATA_LEN-3)))...
        else
            data=$(printf "%-${max_data_len}s" "$data")
        fi
    fi

    # Tokyo Storm themed output
    if [[ "$name" == *"OS"* ]] || [[ "$name" == *"KERNEL"* ]] || [[ "$name" == *"HOSTNAME"* ]] || [[ "$name" == *"PROCESSOR"* ]] || [[ "$name" == *"VOLUME"* ]] || [[ "$name" == *"MEMORY"* ]]; then
        printf "${COLOR_BORDER}│${COLOR_RESET} ${COLOR_HIGHLIGHT}%-${MAX_NAME_LEN}s${COLOR_RESET} ${COLOR_BORDER}│${COLOR_RESET} ${COLOR_FG}%s${COLOR_RESET} ${COLOR_BORDER}│${COLOR_RESET}\n" "$name" "$data"
    else
        printf "${COLOR_BORDER}│${COLOR_RESET} ${COLOR_FG}%-${MAX_NAME_LEN}s${COLOR_RESET} ${COLOR_BORDER}│${COLOR_RESET} ${COLOR_FG}%s${COLOR_RESET} ${COLOR_BORDER}│${COLOR_RESET}\n" "$name" "$data"
    fi
}

PRINT_FOOTER() {
    local length=$((CURRENT_LEN+MAX_NAME_LEN+BORDERS_AND_PADDING))
    local footer="${COLOR_BORDER}└"
    for (( i = 0; i < length - 3; i++ )); do
        footer+="${COLOR_BORDER}─"
        if [ "$i" -eq 14 ]; then
            footer+="${COLOR_BORDER}┴"
        fi
    done
    footer+="${COLOR_BORDER}┘${COLOR_RESET}"
    printf '%s\n' "$footer"
}

bar_graph() {
    local percent
    local num_blocks
    # Use slightly less than CURRENT_LEN to avoid truncation issues
    local width=$((CURRENT_LEN - 2)) 
    local graph=""
    local used=$1
    local total=$2

    if (( $(echo "$total == 0" | bc -l) )); then
        percent=0
    else
        percent=$(awk -v used="$used" -v total="$total" 'BEGIN { printf "%.2f", (used / total) * 100 }')
    fi

    num_blocks=$(awk -v percent="$percent" -v width="$width" 'BEGIN { printf "%d", (percent / 100) * width }')

    # Ensure num_blocks doesn't exceed width due to rounding
    if (( num_blocks > width )); then num_blocks=$width; fi

    # Tokyo Storm themed bar graph
    for (( i = 0; i < num_blocks; i++ )); do
        graph+="${COLOR_BAR_USED}█${COLOR_RESET}"
    done
    for (( i = num_blocks; i < width; i++ )); do
        graph+="${COLOR_BAR_FREE}░${COLOR_RESET}"
    done
    # Return exactly width characters (each Unicode char is 3 bytes, but we want width visual chars)
    printf "%s" "${graph}"
}

get_ip_addr() {
    ipv4_address=""
    
    # Priority: Physical interfaces (en*, wl*, eth*, wlan*) first
    if command -v ip &> /dev/null; then
        ipv4_address=$(ip -o -4 addr show | awk '
            $2 ~ /^(en|wl|eth|wlan)/ {split($4, a, "/"); print a[1]; exit}')
        
        # Fallback to any non-loopback/docker if priority search failed
        if [ -z "$ipv4_address" ]; then
             ipv4_address=$(ip -o -4 addr show | awk '
                $2 != "lo" && $2 !~ /^docker/ && $2 !~ /^br-/ && $2 !~ /^veth/ {split($4, a, "/"); if (!found++) print a[1]}')
        fi
    fi

    # Fallback to ifconfig
    if [ -z "$ipv4_address" ] && command -v ifconfig &> /dev/null; then
        ipv4_address=$(ifconfig | awk '
            /^[a-z]/ {iface=$1}
            iface ~ /^(en|wl|eth|wlan)/ && /inet / {print $2; exit}')
    fi

    if [ -z "$ipv4_address" ]; then
        printf '%s' "No IP found"
    else
        printf '%s' "$ipv4_address"
    fi
}

# --- Operating System Information ---
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ -n "$PRETTY_NAME" ]; then
        os_name="${PRETTY_NAME}"
    elif [ -n "$VERSION" ]; then
        os_name="${ID^} ${VERSION} ${VERSION_CODENAME^}"
    else
        os_name="${ID^} Rolling"
    fi
else
    os_name="Unknown Linux"
fi
os_kernel=$({ uname; uname -r; } | tr '\n' ' ')

# --- Network Information ---
net_current_user=$(whoami)

if [ -f /etc/hostname ]; then
    net_hostname=$(head -n 1 /etc/hostname)
elif command -v hostname &> /dev/null; then
    net_hostname=$(hostname -f 2>/dev/null || hostname)
else
    net_hostname=$(grep -w "$(uname -n)" /etc/hosts | awk '{print $2}' | head -n 1)
fi

if [ -z "$net_hostname" ]; then net_hostname="Not Defined"; fi

net_machine_ip=$(get_ip_addr)
net_client_raw=$(who -m 2>/dev/null || echo "") 
net_client_ip=$(echo "$net_client_raw" | awk '{print $5}' | tr -d '()')
if [ -z "$net_client_ip" ]; then
    net_client_ip="Local/Unknown"
fi

net_dns_ip=($(grep '^nameserver' /etc/resolv.conf | awk '{print $2}' | grep -v '127.0.0.53'))
if [ ${#net_dns_ip[@]} -eq 0 ]; then
    net_dns_ip=("Systemd/Local")
fi

# --- CPU Information ---
cpu_model="$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
cpu_hypervisor="$(lscpu | grep 'Hypervisor vendor' | sed 's/Hypervisor vendor:\s*//')"
if [ -z "$cpu_hypervisor" ]; then
    cpu_hypervisor="Bare Metal"
fi

# Use nproc --all for logical CPUs (Threads)
cpu_cores_logical="$(nproc --all)"

# Try to get Max MHz first (more accurate for specs), fallback to current
cpu_freq=$(lscpu | grep "CPU max MHz" | awk '{printf "%.2f", $4/1000}')
if [ -z "$cpu_freq" ]; then
    cpu_freq=$(grep 'cpu MHz' /proc/cpuinfo | head -n 1 | awk '{ printf "%.2f", $4 / 1000 }')
fi

load_avg_1min=$(uptime | awk -F'load average: ' '{print $2}' | cut -d ',' -f1 | tr -d ' ')
load_avg_5min=$(uptime | awk -F'load average: ' '{print $2}' | cut -d ',' -f2 | tr -d ' ')
load_avg_15min=$(uptime| awk -F'load average: ' '{print $2}' | cut -d ',' -f3 | tr -d ' ')

# --- Memory Information ---
mem_total=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
mem_available=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_available))
mem_percent=$(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%.2f", (used / total) * 100 }')
mem_total_gb=$(echo "$mem_total" | awk '{ printf "%.2f", $1 / (1024 * 1024) }') 
mem_available_gb=$(echo "$mem_available" | awk '{ printf "%.2f", $1 / (1024 * 1024) }')
mem_used_gb=$(echo "$mem_used" | awk '{ printf "%.2f", $1 / (1024 * 1024) }')

# --- Disk Information ---
if [ "$(command -v zfs)" ] && [ "$(grep -q "zfs" /proc/mounts)" ]; then
    zfs_present=1
    zfs_health=$(zpool status -x zroot 2>/dev/null | grep -q "is healthy" && echo "HEALTH O.K." || echo "Check Status")
    zfs_available=$(zfs get -o value -Hp available "$zfs_filesystem" 2>/dev/null)
    zfs_used=$(zfs get -o value -Hp used "$zfs_filesystem" 2>/dev/null)
    
    if [ -z "$zfs_used" ]; then 
         zfs_used=0; zfs_available=1; 
    fi

    zfs_available_gb=$(echo "$zfs_available" | awk '{ printf "%.2f", $1 / (1024 * 1024 * 1024) }')
    zfs_used_gb=$(echo "$zfs_used" | awk '{ printf "%.2f", $1 / (1024 * 1024 * 1024) }')
    disk_percent=$(awk -v used="$zfs_used" -v available="$zfs_available" 'BEGIN { if (available > 0) printf "%.2f", (used / (used+available)) * 100; else print "0" }')
else
    root_partition="/"
    root_used=$(df -m "$root_partition" | awk 'NR==2 {print $3}')
    root_total=$(df -m "$root_partition" | awk 'NR==2 {print $2}')
    root_total_gb=$(awk -v total="$root_total" 'BEGIN { printf "%.2f", total / 1024 }')
    root_used_gb=$(awk -v used="$root_used" 'BEGIN { printf "%.2f", used / 1024 }')
    disk_percent=$(awk -v used="$root_used" -v total="$root_total" 'BEGIN { printf "%.2f", (used / total) * 100 }')
fi

# --- Last login and Uptime ---
# Use 'last' command instead of lastlog for more accurate results
if command -v last &> /dev/null; then
    last_login_raw=$(last -1 "$USER" 2>/dev/null | head -1)
    
    if [[ -n "$last_login_raw" ]] && [[ "$last_login_raw" != *"wtmp begins"* ]]; then
        # Parse the last login time and IP
        last_login_time=$(echo "$last_login_raw" | awk '{print $4, $5, $6, $7, $8}' | sed 's/  */ /g')
        last_login_ip=$(echo "$last_login_raw" | awk '{print $3}' | tr -d '()')
        
        if [[ "$last_login_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            last_login_ip_present=1
        else
            last_login_ip_present=0
        fi
        
        # Clean up the time format
        last_login_time=$(echo "$last_login_time" | sed 's/  */ /g' | sed 's/^ *//; s/ *$//')
    else
        last_login_time="Never logged in"
        last_login_ip_present=0
    fi
else
    last_login_time="Unavailable"
    last_login_ip_present=0
fi

sys_uptime=$(uptime -p | sed 's/up\s*//; s/\s*day\(s*\)/d/; s/\s*hour\(s*\)/h/; s/\s*minute\(s*\)/m/')

# --- OS Age Information ---
os_age_text="N/A"
if command -v pacman &> /dev/null; then
    # Use the earliest pacman log entry as a proxy for OS Age
    # This is more accurate than filesystem package install date
    if [ -f "/var/log/pacman.log" ]; then
        # Get the first pacman operation date
        first_install_date=$(head -1 /var/log/pacman.log | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}' | head -1)
        
        if [ -n "$first_install_date" ]; then
            # Try to calculate difference in seconds
            install_epoch=$(date -d "$first_install_date" +%s 2>/dev/null)
            
            if [ $? -eq 0 ] && [ "$install_epoch" -gt 0 ]; then
                current_epoch=$(date +%s)
                age_seconds=$((current_epoch - install_epoch))
                os_age_days=$((age_seconds / 86400)) # 60 * 60 * 24
                os_age_text="${os_age_days} days" 
            fi
        fi
    fi
fi

# Set current length before graphs get calculated
set_current_len

# Create graphs
cpu_1min_bar_graph=$(bar_graph "$load_avg_1min" "$cpu_cores_logical")
cpu_5min_bar_graph=$(bar_graph "$load_avg_5min" "$cpu_cores_logical")
cpu_15min_bar_graph=$(bar_graph "$load_avg_15min" "$cpu_cores_logical")
mem_bar_graph=$(bar_graph "$mem_used" "$mem_total")

if [ $zfs_present -eq 1 ]; then
    disk_bar_graph=$(bar_graph "$zfs_used" $((zfs_used + zfs_available)) )
else
    disk_bar_graph=$(bar_graph "$root_used" "$root_total")
fi

# --- Print Report ---
PRINT_HEADER
PRINT_CENTERED_DATA "$report_title"
PRINT_CENTERED_DATA "TR-100 MACHINE REPORT"
PRINT_DIVIDER "top"
PRINT_DATA "OS" "$os_name"
PRINT_DATA "KERNEL" "$os_kernel"
PRINT_DIVIDER
PRINT_DATA "HOSTNAME" "$net_hostname"
PRINT_DATA "MACHINE IP" "$net_machine_ip"
PRINT_DATA "CLIENT  IP" "$net_client_ip"

for dns_num in "${!net_dns_ip[@]}"; do
    PRINT_DATA "DNS  IP $(($dns_num + 1))" "${net_dns_ip[dns_num]}"
done

PRINT_DATA "USER" "$net_current_user"
PRINT_DIVIDER
PRINT_DATA "PROCESSOR" "$cpu_model"
PRINT_DATA "CORES" "$cpu_cores_logical Logical CPU(s)"
PRINT_DATA "HYPERVISOR" "$cpu_hypervisor"
PRINT_DATA "CPU FREQ" "$cpu_freq GHz"
PRINT_DATA "LOAD  1m" "$cpu_1min_bar_graph"
PRINT_DATA "LOAD  5m" "$cpu_5min_bar_graph"
PRINT_DATA "LOAD 15m" "$cpu_15min_bar_graph"

if [ $zfs_present -eq 1 ]; then
    PRINT_DIVIDER
    PRINT_DATA "VOLUME" "$zfs_used_gb/$zfs_available_gb GB [$disk_percent%]"
    PRINT_DATA "DISK USAGE" "$disk_bar_graph"
    PRINT_DATA "ZFS HEALTH" "$zfs_health"
else
    PRINT_DIVIDER
    PRINT_DATA "VOLUME" "$root_used_gb/$root_total_gb GB [$disk_percent%]"
    PRINT_DATA "DISK USAGE" "$disk_bar_graph"
fi

PRINT_DIVIDER
PRINT_DATA "MEMORY" "${mem_used_gb}/${mem_total_gb} GiB [${mem_percent}%]"
PRINT_DATA "USAGE" "${mem_bar_graph}"
PRINT_DIVIDER
PRINT_DATA "LAST LOGIN" "$last_login_time"

if [ $last_login_ip_present -eq 1 ]; then
    PRINT_DATA "" "$last_login_ip"
fi

PRINT_DATA "UPTIME" "$sys_uptime"
PRINT_DATA "OS AGE" "$os_age_text"
PRINT_DIVIDER "bottom"
