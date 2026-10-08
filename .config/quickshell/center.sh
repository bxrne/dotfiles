#!/usr/bin/env bash
# Status and actions for the quickshell control centre.
# Prints key=value or key<TAB>fields lines. Notes are "note=...".
set -u

note() { printf 'note=%s\n' "$*"; }

wifi_device() {
  nmcli -t -f DEVICE,TYPE device status 2>/dev/null | awk -F: '$2=="wifi" {print $1; exit}'
}

status_wifi() {
  if ! command -v nmcli >/dev/null 2>&1; then
    echo "wifi_radio=missing"
    return
  fi
  local radio
  radio=$(nmcli -t -f WIFI radio 2>/dev/null || true)
  if [[ $radio == enabled ]]; then
    echo "wifi_radio=on"
  else
    echo "wifi_radio=off"
  fi
  local active
  active=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | awk -F: '$2=="802-11-wireless" {print $1; exit}')
  printf 'wifi_active=%s\n' "$active"
  python3 - "$active" <<'PY'
import subprocess, sys
active = sys.argv[1]
try:
    raw = subprocess.check_output(
        ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "device", "wifi", "list", "--rescan", "no"],
        text=True,
    )
except subprocess.CalledProcessError:
    sys.exit(0)

def split_nm(line):
    parts, cur, esc = [], "", False
    for c in line.rstrip("\n"):
        if esc:
            cur += c
            esc = False
        elif c == "\\":
            esc = True
        elif c == ":":
            parts.append(cur)
            cur = ""
        else:
            cur += c
    parts.append(cur)
    return parts

best = {}
for line in raw.splitlines():
    parts = split_nm(line)
    if len(parts) < 3:
        continue
    in_use, ssid, signal = parts[0], parts[1], parts[2]
    security = parts[3] if len(parts) > 3 else ""
    if not ssid:
        continue
    try:
        sig = int(signal)
    except ValueError:
        sig = 0
    secure = security not in ("", "--")
    prev = best.get(ssid)
    if prev is None or sig > prev[0]:
        best[ssid] = (sig, secure, in_use == "*" or ssid == active)
items = sorted(best.items(), key=lambda kv: -kv[1][0])[:4]
for ssid, (sig, secure, on) in items:
    ssid = ssid.replace("\t", " ")
    print(f"wifi_net\t{ssid}\t{sig}\t{'yes' if secure else 'no'}\t{'yes' if on else 'no'}")
PY
}

status_bt() {
  if ! command -v bluetoothctl >/dev/null 2>&1; then
    echo "bt_state=unavailable"
    return
  fi
  local show
  show=$(bluetoothctl show 2>/dev/null || true)
  if [[ -z $show ]]; then
    echo "bt_state=down"
    return
  fi
  echo "bt_state=up"
  if grep -q 'Powered: yes' <<<"$show"; then
    echo "bt_power=on"
  else
    echo "bt_power=off"
  fi
  python3 - <<'PY'
import subprocess
def devices(args):
    try:
        raw = subprocess.check_output(["bluetoothctl", *args], text=True, stderr=subprocess.DEVNULL)
    except subprocess.CalledProcessError:
        return []
    out = []
    for line in raw.splitlines():
        parts = line.split(None, 2)
        if len(parts) >= 2 and parts[0] == "Device":
            out.append((parts[1], parts[2] if len(parts) > 2 else parts[1]))
    return out
connected = {mac for mac, _ in devices(["devices", "Connected"])}
shown = 0
seen = set()
for mac, name in devices(["devices", "Connected"]) + devices(["devices"]):
    if mac in seen:
        continue
    seen.add(mac)
    state = "connected" if mac in connected else "paired"
    name = name.replace("\t", " ")
    print(f"bt_dev\t{mac}\t{name}\t{state}")
    shown += 1
    if shown >= 4:
        break
PY
}

status_displays() {
  python3 - <<'PY'
import json, subprocess, sys
try:
    data = json.loads(subprocess.check_output(["niri", "msg", "-j", "outputs"], text=True))
except Exception as exc:
    print(f"note=Could not list screens: {exc}")
    sys.exit(0)
for name, info in data.items():
    logical = info.get("logical") or {}
    model = info.get("model") or ""
    kind = "Built-in screen" if name.startswith("eDP") else "External screen"
    label = kind if not model or model == "Unknown" else f"{kind} · {model}"
    label = label.replace("\t", " ")
    print(f"display\t{name}\t{label}\t{logical.get('width', '')}\t{logical.get('x', 0)}\t{logical.get('y', 0)}")
PY
  local casts
  casts=$(niri msg -j casts 2>/dev/null || echo '[]')
  python3 - "$casts" <<'PY'
import json, sys
try:
    data = json.loads(sys.argv[1] or "[]")
except json.JSONDecodeError:
    data = []
print(f"cast_count={len(data)}")
PY
  if pgrep -x wl-mirror >/dev/null 2>&1; then
    echo "mirror=on"
  else
    echo "mirror=off"
  fi
  if pgrep -x wf-recorder >/dev/null 2>&1; then
    echo "recording=on"
  else
    echo "recording=off"
  fi
}

cmd_status() {
  status_wifi
  status_bt
  status_displays
}

cmd_wifi_toggle() {
  local radio
  radio=$(nmcli -t -f WIFI radio 2>/dev/null || true)
  if [[ $radio == enabled ]]; then
    nmcli radio wifi off >/dev/null
    note "Wi-Fi turned off"
  else
    nmcli radio wifi on >/dev/null
    note "Wi-Fi turned on"
  fi
}

cmd_wifi_rescan() {
  nmcli device wifi list --rescan yes >/dev/null
  note "Rescanned Wi-Fi"
}

cmd_wifi_disconnect() {
  local dev
  dev=$(wifi_device)
  if [[ -z $dev ]]; then
    note "No Wi-Fi device"
    return
  fi
  nmcli device disconnect "$dev" >/dev/null
  note "Disconnected Wi-Fi"
}

cmd_wifi_connect() {
  local ssid=${1:-} pass=${2:-} err
  if [[ -z $ssid ]]; then
    note "No network selected"
    return
  fi
  if [[ -n $pass ]]; then
    err=$(nmcli device wifi connect "$ssid" password "$pass" 2>&1) || { note "$err"; return; }
  else
    err=$(nmcli device wifi connect "$ssid" 2>&1) || { note "$err"; return; }
  fi
  note "Connected to $ssid"
}

cmd_wifi_tui() {
  niri msg action spawn -- foot -e nmtui
  note "Opened Wi-Fi settings"
}

cmd_bt_toggle() {
  if ! command -v bluetoothctl >/dev/null 2>&1; then
    note "Bluetooth is not installed yet. Rebuild NixOS, then log in again."
    return
  fi
  if ! bluetoothctl show >/dev/null 2>&1; then
    note "Bluetooth service is not running. Rebuild NixOS, then log in again."
    return
  fi
  if bluetoothctl show | grep -q 'Powered: yes'; then
    bluetoothctl power off >/dev/null
    note "Bluetooth turned off"
  else
    bluetoothctl power on >/dev/null
    note "Bluetooth turned on"
  fi
}

cmd_bt_scan() {
  if ! command -v bluetoothctl >/dev/null 2>&1 || ! bluetoothctl show >/dev/null 2>&1; then
    note "Bluetooth is not running yet. Rebuild NixOS, then log in again."
    return
  fi
  bluetoothctl power on >/dev/null 2>&1 || true
  setsid -f bluetoothctl --timeout 8 scan on >/dev/null 2>&1
  note "Scanning for devices"
}

cmd_bt_tui() {
  if ! command -v bluetui >/dev/null 2>&1; then
    note "bluetui is not installed yet. Rebuild NixOS, then log in again."
    return
  fi
  niri msg action spawn -- foot -e bluetui
  note "Opened Bluetooth"
}

cmd_bt_toggle_dev() {
  local mac=${1:-} state=${2:-}
  if [[ -z $mac ]]; then
    note "No device selected"
    return
  fi
  if [[ $state == connected ]]; then
    bluetoothctl disconnect "$mac" >/dev/null
    note "Disconnected $mac"
  else
    bluetoothctl connect "$mac" >/dev/null
    note "Connecting to $mac"
  fi
}

external_output() {
  python3 - <<'PY'
import json, subprocess, sys
data = json.loads(subprocess.check_output(["niri", "msg", "-j", "outputs"], text=True))
for name in data:
    if not name.startswith("eDP"):
        print(name)
        sys.exit(0)
sys.exit(1)
PY
}

internal_output() {
  python3 - <<'PY'
import json, subprocess, sys
data = json.loads(subprocess.check_output(["niri", "msg", "-j", "outputs"], text=True))
for name in data:
    if name.startswith("eDP"):
        print(name)
        sys.exit(0)
print(next(iter(data)))
PY
}

cmd_extend() {
  python3 - <<'PY'
import json, subprocess, sys
data = json.loads(subprocess.check_output(["niri", "msg", "-j", "outputs"], text=True))
internals = [n for n in data if n.startswith("eDP")]
base_name = internals[0] if internals else next(iter(data))
base = data[base_name]["logical"]
x = int(base["x"] + base["width"])
y = int(base["y"])
moved = 0
for name, info in data.items():
    if name == base_name:
        continue
    subprocess.check_call(["niri", "msg", "output", name, "position", "set", str(x), str(y)])
    y += int(info["logical"]["height"])
    moved += 1
print(f"note={'Extended screens to the right' if moved else 'Plug in another screen to extend'}")
PY
  pkill -x wl-mirror >/dev/null 2>&1 || true
}

cmd_auto_arrange() {
  python3 - <<'PY'
import json, subprocess
data = json.loads(subprocess.check_output(["niri", "msg", "-j", "outputs"], text=True))
for name in data:
    subprocess.check_call(["niri", "msg", "output", name, "position", "auto"])
print("note=Screens arranged automatically")
PY
  pkill -x wl-mirror >/dev/null 2>&1 || true
}

cmd_mirror() {
  local ext int
  ext=$(external_output 2>/dev/null || true)
  int=$(internal_output 2>/dev/null || true)
  if [[ -z $ext ]]; then
    note "Plug in another screen to mirror"
    return
  fi
  if ! command -v wl-mirror >/dev/null 2>&1; then
    note "wl-mirror is not installed yet. Rebuild NixOS, then log in again."
    return
  fi
  pkill -x wl-mirror >/dev/null 2>&1 || true
  if wl-mirror --help 2>&1 | grep -q -- '--fullscreen-output'; then
    setsid -f wl-mirror --fullscreen --fullscreen-output "$ext" "$int" >/dev/null 2>&1
  else
    setsid -f wl-mirror "$int" >/dev/null 2>&1
  fi
  note "Mirroring the built-in screen onto $ext"
}

cmd_unmirror() {
  pkill -x wl-mirror >/dev/null 2>&1 || true
  note "Stopped mirroring"
}

cmd_share() {
  niri msg action set-dynamic-cast-monitor >/dev/null
  note "This screen is the share target. Start sharing from the app."
}

cmd_share_stop() {
  python3 - <<'PY'
import json, subprocess
data = json.loads(subprocess.check_output(["niri", "msg", "-j", "casts"], text=True) or "[]")
stopped = 0
for cast in data:
    sid = cast.get("session_id")
    if not sid:
        continue
    subprocess.call(["niri", "msg", "action", "stop-cast", "--session-id", sid])
    stopped += 1
print(f"note={'Stopped sharing' if stopped else 'No active screen share'}")
PY
  niri msg action clear-dynamic-cast-target >/dev/null 2>&1 || true
}

# Drag-select. Spawned by niri, not by the panel, so the click that
# opened Capture cannot cancel the selection.
select_region() {
  slurp -b '#1d2021cc' -c '#8ec07cff' -s '#8ec07c55' -w 2
}

cmd_record() {
  local mode=${1:-screen}
  if ! command -v wf-recorder >/dev/null 2>&1; then
    note "wf-recorder is not installed yet. Rebuild NixOS, then log in again."
    return
  fi
  if pgrep -x wf-recorder >/dev/null 2>&1; then
    note "Already recording"
    return
  fi
  if [[ $mode == region ]]; then
    niri msg action spawn -- bash -lc "sleep 0.45; exec $HOME/.config/quickshell/center.sh record-region-now"
    note "Drag to select a region. Escape cancels."
    return
  fi
  sleep 0.3
  cmd_record_file
  note "Recording to Videos"
}

cmd_record_file() {
  mkdir -p "$HOME/Videos" "$HOME/.cache"
  local file geom
  file="$HOME/Videos/Recording from $(date '+%Y-%m-%d %H-%M-%S').mp4"
  printf '%s\n' "$file" > "$HOME/.cache/nixbook-recording"
  local -a args=(-f "$file" -c libx264)
  if [[ -n ${1:-} ]]; then
    args+=(-g "$1")
  fi
  if command -v wpctl >/dev/null 2>&1; then
    args+=(-a)
  fi
  setsid -f wf-recorder "${args[@]}" >"$HOME/.cache/nixbook-recording.log" 2>&1
}

cmd_record_region_now() {
  local geom
  geom=$(select_region) || exit 0
  cmd_record_file "$geom"
}

cmd_record_stop() {
  if ! pgrep -x wf-recorder >/dev/null 2>&1; then
    note "Not recording"
    return
  fi
  pkill -INT -x wf-recorder >/dev/null 2>&1 || true
  note "Recording saved to Videos"
}

cmd_shot() {
  local which=${1:-screen}
  case $which in
    region)
      niri msg action spawn -- bash -lc "sleep 0.45; exec $HOME/.config/quickshell/center.sh shot-region-now"
      note "Drag to select a region. Escape cancels."
      ;;
    screen) niri msg action screenshot-screen >/dev/null; note "Copied this screen" ;;
    window) niri msg action screenshot-window >/dev/null; note "Copied this window" ;;
    picker) niri msg action screenshot >/dev/null; note "Opened the screenshot picker" ;;
  esac
}

cmd_shot_region_now() {
  local geom file
  geom=$(select_region) || exit 0
  mkdir -p "$HOME/Pictures/Screenshots"
  file="$HOME/Pictures/Screenshots/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"
  grim -g "$geom" "$file"
  wl-copy <"$file"
  command -v notify-send >/dev/null 2>&1 && notify-send -a capture "Screenshot" "Saved and copied the region"
}

case ${1:-status} in
  status) cmd_status ;;
  wifi-toggle) cmd_wifi_toggle ;;
  wifi-rescan) cmd_wifi_rescan ;;
  wifi-disconnect) cmd_wifi_disconnect ;;
  wifi-connect) cmd_wifi_connect "${2:-}" "${3:-}" ;;
  wifi-tui) cmd_wifi_tui ;;
  bt-toggle) cmd_bt_toggle ;;
  bt-scan) cmd_bt_scan ;;
  bt-tui) cmd_bt_tui ;;
  bt-dev) cmd_bt_toggle_dev "${2:-}" "${3:-}" ;;
  extend) cmd_extend ;;
  arrange) cmd_auto_arrange ;;
  mirror) cmd_mirror ;;
  unmirror) cmd_unmirror ;;
  share) cmd_share ;;
  share-stop) cmd_share_stop ;;
  shot) cmd_shot "${2:-screen}" ;;
  shot-region-now) cmd_shot_region_now ;;
  record) cmd_record "${2:-screen}" ;;
  record-region-now) cmd_record_region_now ;;
  record-stop) cmd_record_stop ;;
  *) note "Unknown action: $1" ;;
esac
