import QtQuick
import Quickshell
import Quickshell.Io

PanelWindow {
    id: win
    required property QtObject theme
    property bool open: false
    property string selected: ""
    property string zone: "rail"
    property int railIndex: 0
    property int paneIndex: 0
    readonly property var cats: ["volume", "brightness", "wifi", "bluetooth", "capture", "displays", "session"]
    property string clock: Qt.formatDateTime(new Date(), "HH:mm")
    property string date: Qt.formatDateTime(new Date(), "ddd d MMM")
    property string volume: "—"
    property string battery: "—"
    property string brightness: "—"
    property string uptime: "—"
    property string lastLogin: "—"
    property int volumePct: 0
    property bool muted: false
    property int brightPct: 0
    property string note: ""
    property string wifiRadio: "unknown"
    property string wifiActive: ""
    property string btState: "unknown"
    property string btPower: "off"
    property int castCount: 0
    property string mirror: "off"
    property string recording: "off"
    property string pendingSsid: ""
    property var networks: []
    property var devices: []
    property var displays: []

    readonly property int paneW: 520
    readonly property string centerScript: "/home/bxrne/.config/quickshell/center.sh"

    visible: open
    focusable: true
    aboveWindows: true
    exclusiveZone: 0
    color: "#000000aa"
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    function toggle() {
        open = !open;
        if (open)
            Qt.callLater(() => keys.forceActiveFocus());
    }
    function pick(id) { selected = selected === id ? "" : id; }
    function paneCount() {
        switch (selected) {
        case "volume": return 3;
        case "brightness": return 2;
        case "wifi": return 4 + networks.length + (pendingSsid !== "" ? 1 : 0);
        case "bluetooth": return 3 + devices.length;
        case "capture": return 9;
        case "displays": return 4;
        case "session": return 1;
        default: return 0;
        }
    }
    function moveRail(delta) {
        zone = "rail";
        pendingSsid = "";
        if (selected === "") {
            selected = cats[railIndex];
            return;
        }
        railIndex = (railIndex + delta + cats.length) % cats.length;
        selected = cats[railIndex];
        paneIndex = 0;
    }
    function enterPane() {
        selected = cats[railIndex];
        if (paneCount() === 0)
            return;
        zone = "pane";
        paneIndex = Math.min(paneIndex, paneCount() - 1);
        keys.forceActiveFocus();
    }
    function movePane(delta) {
        const n = paneCount();
        if (n <= 0) {
            zone = "rail";
            return;
        }
        zone = "pane";
        paneIndex = (paneIndex + delta + n) % n;
        if (scroller)
            scroller.contentY = Math.max(0, paneIndex * 52 - 24);
        keys.forceActiveFocus();
    }
    function press(cat, index) {
        const i = cats.indexOf(cat);
        if (i >= 0)
            railIndex = i;
        selected = cat;
        zone = "pane";
        paneIndex = index;
        activate(cat, index);
    }
    function activate(cat, index) {
        if (cat === "volume") {
            if (index === 0) { bumpVolume(-5); run(volDown); }
            else if (index === 1) { bumpVolume(5); run(volUp); }
            else { toggleMute(); run(volMute); }
        } else if (cat === "brightness") {
            if (index === 0) { bumpBright(-10); run(dim); }
            else { bumpBright(10); run(bright); }
        } else if (cat === "wifi") {
            if (index === 0) act(["wifi-toggle"]);
            else if (index === 1) act(["wifi-rescan"]);
            else if (index === 2) act(["wifi-disconnect"]);
            else if (index === 3) { act(["wifi-tui"]); open = false; }
            else if (index === 4 + networks.length && pendingSsid !== "") act(["wifi-connect", pendingSsid, wifiPass.text]);
            else chooseWifi(index - 4);
        } else if (cat === "bluetooth") {
            if (index === 0) act(["bt-toggle"]);
            else if (index === 1) act(["bt-scan"]);
            else if (index === 2) { act(["bt-tui"]); open = false; }
            else {
                const dev = devices[index - 3];
                if (dev) act(["bt-dev", dev.mac, dev.state]);
            }
        } else if (cat === "capture") {
            if (index === 0) { open = false; act(["shot", "region"]); }
            else if (index === 1) { open = false; act(["shot", "screen"]); }
            else if (index === 2) { open = false; act(["shot", "window"]); }
            else if (index === 3) { open = false; act(["shot", "picker"]); }
            else if (index === 4) { open = false; act(["record", "screen"]); }
            else if (index === 5) { open = false; act(["record", "region"]); }
            else if (index === 6) act(["record-stop"]);
            else if (index === 7) act(["share"]);
            else act(["share-stop"]);
        } else if (cat === "displays") {
            if (index === 0) act(["extend"]);
            else if (index === 1) act(["mirror"]);
            else if (index === 2) act(["unmirror"]);
            else act(["arrange"]);
        } else if (cat === "session") {
            run(lock);
            open = false;
        }
    }
    function chooseWifi(index) {
        const net = networks[index];
        if (!net || net.active)
            return;
        if (net.secure) {
            pendingSsid = net.ssid;
            wifiPass.text = "";
            wifiPass.forceActiveFocus();
        } else {
            pendingSsid = "";
            act(["wifi-connect", net.ssid]);
        }
    }
    function handleKey(event) {
        const k = event.key;
        event.accepted = true;
        if (k === Qt.Key_Up)
            zone === "pane" ? movePane(-1) : moveRail(-1);
        else if (k === Qt.Key_Down)
            zone === "pane" ? movePane(1) : moveRail(1);
        else if (k === Qt.Key_Left || k === Qt.Key_Backtab) {
            if (zone === "pane")
                zone = "rail";
            else
                moveRail(-1);
        } else if (k === Qt.Key_Right || k === Qt.Key_Tab) {
            if (zone === "rail")
                enterPane();
            else
                movePane(1);
        } else if (k === Qt.Key_Return || k === Qt.Key_Enter || k === Qt.Key_Space) {
            if (zone === "rail")
                enterPane();
            else
                activate(selected, paneIndex);
        } else if (k === Qt.Key_Escape) {
            if (zone === "pane") {
                zone = "rail";
                pendingSsid = "";
            } else
                open = false;
        } else
            event.accepted = false;
    }
    function run(proc) {
        proc.running = false;
        proc.running = true;
    }
    function showVolume() {
        volume = volumePct + "%" + (muted ? "  muted" : "");
    }
    function bumpVolume(delta) {
        volumePct = Math.max(0, Math.min(100, volumePct + delta));
        showVolume();
    }
    function toggleMute() {
        muted = !muted;
        showVolume();
    }
    function bumpBright(delta) {
        brightPct = Math.max(0, Math.min(100, brightPct + delta));
        brightness = brightPct + "%";
    }
    function act(args) {
        actionProc.running = false;
        actionProc.command = [centerScript].concat(args);
        actionProc.running = true;
    }
    function applyStatus(text) {
        const nets = [];
        const devs = [];
        const outs = [];
        const lines = text.split("\n");
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i];
            if (!line)
                continue;
            if (line.indexOf("\t") >= 0) {
                const p = line.split("\t");
                if (p[0] === "wifi_net")
                    nets.push({ ssid: p[1], signal: p[2], secure: p[3] === "yes", active: p[4] === "yes" });
                else if (p[0] === "bt_dev")
                    devs.push({ mac: p[1], name: p[2] || p[1], state: p[3] });
                else if (p[0] === "display")
                    outs.push({ name: p[1], label: p[2], width: p[3], x: p[4], y: p[5] });
                continue;
            }
            const eq = line.indexOf("=");
            if (eq < 0)
                continue;
            const key = line.slice(0, eq);
            const val = line.slice(eq + 1);
            if (key === "note") note = val;
            else if (key === "wifi_radio") wifiRadio = val;
            else if (key === "wifi_active") wifiActive = val;
            else if (key === "bt_state") btState = val;
            else if (key === "bt_power") btPower = val;
            else if (key === "cast_count") castCount = parseInt(val) || 0;
            else if (key === "mirror") mirror = val;
            else if (key === "recording") recording = val;
        }
        networks = nets;
        devices = devs;
        displays = outs;
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            const now = new Date();
            win.clock = Qt.formatDateTime(now, "HH:mm");
            win.date = Qt.formatDateTime(now, "ddd d MMM");
        }
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text.trim().replace(/^Volume:\s*/i, "");
                const n = parseFloat(raw);
                win.muted = raw.includes("[MUTED]");
                if (!isNaN(n)) win.volumePct = Math.round(n * 100);
                win.showVolume();
            }
        }
    }
    Process {
        id: batProc
        command: ["bash", "-lc", "printf '%s%%  %s\\n' \"$(cat /sys/class/power_supply/BAT0/capacity)\" \"$(cat /sys/class/power_supply/BAT0/status)\""]
        stdout: StdioCollector {
            onStreamFinished: if (this.text.trim()) win.battery = this.text.trim()
        }
    }
    Process {
        id: infoProc
        command: ["bash", "-lc", "b=$(brightnessctl -d gmux_backlight -m | cut -d, -f4); u=$(awk '{s=int($1); printf \"%dd %dh %dm\", s/86400, (s%86400)/3600, (s%3600)/60}' /proc/uptime); l=$(last -F | awk '/reboot/ && !/1970/ && !/still running/ {print $5,$6,$7,$8,$9; exit}'); printf '%s\\n%s\\n%s\\n' \"$b\" \"$u\" \"${l:-none recorded}\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n");
                if (lines[0]) {
                    win.brightness = lines[0];
                    const b = parseInt(lines[0]);
                    if (!isNaN(b)) win.brightPct = b;
                }
                if (lines[1]) win.uptime = lines[1];
                if (lines[2]) win.lastLogin = lines[2];
            }
        }
    }
    Process {
        id: statusProc
        command: [win.centerScript, "status"]
        stdout: StdioCollector {
            onStreamFinished: win.applyStatus(this.text)
        }
    }
    Process {
        id: actionProc
        command: ["true"]
        stdout: StdioCollector {
            onStreamFinished: {
                win.applyStatus(this.text);
                win.run(statusProc);
            }
        }
    }
    Process {
        id: volDown
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
        onRunningChanged: if (!running) win.run(volProc)
    }
    Process {
        id: volUp
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+", "-l", "1.0"]
        onRunningChanged: if (!running) win.run(volProc)
    }
    Process {
        id: volMute
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onRunningChanged: if (!running) win.run(volProc)
    }
    Process {
        id: dim
        command: ["brightnessctl", "-d", "gmux_backlight", "set", "10%-"]
        onRunningChanged: if (!running) win.run(infoProc)
    }
    Process {
        id: bright
        command: ["brightnessctl", "-d", "gmux_backlight", "set", "+10%"]
        onRunningChanged: if (!running) win.run(infoProc)
    }
    Process { id: lock; command: ["swaylock"] }

    Timer {
        interval: 4000
        running: win.open
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            win.run(volProc);
            win.run(batProc);
            win.run(infoProc);
            if (!actionProc.running)
                win.run(statusProc);
        }
    }

    onOpenChanged: if (open) {
        note = "";
        pendingSsid = "";
        zone = "rail";
        Qt.callLater(() => keys.forceActiveFocus());
    }

    component Cat: Rectangle {
        id: cat
        property string catId: ""
        property string title: ""
        property string detail: ""
        property bool alert: false
        width: 188
        height: 52
        radius: 0
        property bool keyed: win.zone === "rail" && win.cats[win.railIndex] === catId && win.selected !== ""
        color: keyed || win.selected === catId ? theme.bg2 : theme.bg
        border.width: keyed ? 2 : 1
        border.color: alert ? theme.red : (keyed ? theme.bright : (win.selected === catId ? theme.aqua : theme.bg2))
        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            Text {
                text: cat.title
                color: theme.fg
                font.family: theme.font
                font.pixelSize: 14
            }
            Text {
                width: parent.width
                text: cat.detail
                color: cat.alert ? theme.red : theme.fgDim
                font.family: theme.font
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                const i = win.cats.indexOf(cat.catId);
                if (i >= 0)
                    win.railIndex = i;
                win.zone = "rail";
                win.pick(cat.catId);
                keys.forceActiveFocus();
            }
        }
    }

    component Btn: Rectangle {
        id: btn
        property string label: ""
        property bool active: false
        property bool danger: false
        property int nav: -1
        property string navCat: ""
        readonly property bool keyed: nav >= 0 && win.zone === "pane" && win.selected === navCat && win.paneIndex === nav
        signal clicked
        implicitHeight: 48
        radius: 0
        color: active || keyed ? theme.bg2 : theme.bg1
        border.width: keyed ? 2 : 1
        border.color: keyed ? theme.bright : (danger ? theme.red : (active ? theme.aqua : theme.bg2))
        Text {
            anchors.centerIn: parent
            text: btn.label
            color: danger ? theme.red : theme.fg
            font.family: theme.font
            font.pixelSize: 15
        }
        MouseArea {
            anchors.fill: parent
            onClicked: btn.clicked()
        }
    }

    component RowItem: Rectangle {
        id: row
        property string label: ""
        property string detail: ""
        property bool active: false
        property int nav: -1
        property string navCat: ""
        readonly property bool keyed: nav >= 0 && win.zone === "pane" && win.selected === navCat && win.paneIndex === nav
        signal clicked
        width: parent.width
        implicitHeight: 46
        radius: 0
        color: active || keyed ? theme.bg2 : theme.bg1
        border.width: keyed ? 2 : 1
        border.color: keyed ? theme.bright : (active ? theme.aqua : theme.bg2)
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.right: detailText.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: row.label
            color: theme.fg
            font.family: theme.font
            font.pixelSize: 15
            elide: Text.ElideRight
        }
        Text {
            id: detailText
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            text: row.detail
            color: active ? theme.aqua : theme.fgDim
            font.family: theme.font
            font.pixelSize: 13
        }
        MouseArea {
            anchors.fill: parent
            onClicked: row.clicked()
        }
    }

    component Big: Text {
        color: theme.fg
        font.family: theme.font
        font.pixelSize: 36
        font.bold: true
    }

    component Hint: Text {
        width: win.paneW - 48
        color: theme.fgDim
        font.family: theme.font
        font.pixelSize: 14
        wrapMode: Text.WordWrap
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: rail.width + gap.width + 16 + 36
        height: Math.max(rail.height, gap.height) + 36
        color: theme.bgSoft
        border.width: 1
        border.color: theme.bg2

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: keys.forceActiveFocus()
        }

        TextInput {
            id: keys
            width: 1
            height: 1
            opacity: 0
            focus: true
            activeFocusOnTab: true
            onTextChanged: text = ""
            Keys.priority: Keys.BeforeItem
            Keys.onPressed: (event) => win.handleKey(event)
            Keys.onTabPressed: (event) => win.handleKey(event)
            Keys.onBacktabPressed: (event) => win.handleKey(event)
        }

        Row {
            anchors.centerIn: parent
            spacing: 16

            Column {
                id: rail
                spacing: 8
                Cat {
                    catId: "volume"
                    title: "Volume"
                    detail: win.volume
                }
                Cat {
                    catId: "brightness"
                    title: "Brightness"
                    detail: win.brightness
                }
                Cat {
                    catId: "wifi"
                    title: "Wi-Fi"
                    detail: win.wifiRadio === "on" ? (win.wifiActive || "On") : (win.wifiRadio === "off" ? "Off" : "—")
                }
                Cat {
                    catId: "bluetooth"
                    title: "Bluetooth"
                    detail: win.btPower === "on" ? "On" : (win.btState === "up" ? "Off" : "Unavailable")
                }
                Cat {
                    catId: "capture"
                    title: "Capture"
                    detail: win.recording === "on" ? "Recording" : (win.castCount > 0 ? "Sharing" : "Idle")
                    alert: win.recording === "on"
                }
                Cat {
                    catId: "displays"
                    title: "Displays"
                    detail: win.displays.length > 1 ? win.displays.length + " screens" : "Built-in"
                }
                Cat {
                    catId: "session"
                    title: "Session"
                    detail: win.battery
                }
            }

            Rectangle {
                id: gap
                width: win.paneW
                height: rail.height
                color: theme.bg
                border.width: 1
                border.color: win.selected === "" ? theme.bg2 : theme.aqua
                clip: true

                Column {
                    visible: win.selected === ""
                    anchors.centerIn: parent
                    spacing: 8
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: win.clock
                        color: theme.fg
                        font.family: theme.font
                        font.pixelSize: 56
                        font.bold: true
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: win.date
                        color: theme.fgDim
                        font.family: theme.font
                        font.pixelSize: 16
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Arrows move  ·  Tab or Right enters  ·  Esc closes"
                        color: theme.fgDim
                        font.family: theme.font
                        font.pixelSize: 13
                    }
                }

                Flickable {
                    id: scroller
                    anchors.fill: parent
                    anchors.margins: 24
                    visible: win.selected !== ""
                    clip: true
                    contentWidth: width
                    contentHeight: detail.implicitHeight
                    flickableDirection: Flickable.VerticalFlick

                    Column {
                        id: detail
                        width: parent.width
                        spacing: 14

                        Text {
                            text: win.note
                            visible: win.note !== ""
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.aqua
                            font.family: theme.font
                            font.pixelSize: 14
                        }

                        Column {
                            width: parent.width
                            spacing: 14
                            visible: win.selected === "volume"
                            Big { text: win.volume }
                            Hint { text: "Output volume" }
                            Grid {
                                id: volGrid
                                width: parent.width
                                columns: 2
                                columnSpacing: 10
                                rowSpacing: 10
                                Btn {
                                    width: (volGrid.width - 10) / 2
                                    nav: 0
                                    navCat: "volume"
                                    label: "Quieter"
                                    onClicked: win.press("volume", 0)
                                }
                                Btn {
                                    width: (volGrid.width - 10) / 2
                                    nav: 1
                                    navCat: "volume"
                                    label: "Louder"
                                    onClicked: win.press("volume", 1)
                                }
                            }
                            Btn {
                                width: parent.width
                                nav: 2
                                navCat: "volume"
                                label: win.muted ? "Unmute" : "Mute"
                                active: win.muted
                                onClicked: win.press("volume", 2)
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: 14
                            visible: win.selected === "brightness"
                            Big { text: win.brightness }
                            Hint { text: "Built-in screen" }
                            Grid {
                                id: lightGrid
                                width: parent.width
                                columns: 2
                                columnSpacing: 10
                                Btn {
                                    width: (lightGrid.width - 10) / 2
                                    nav: 0
                                    navCat: "brightness"
                                    label: "Dimmer"
                                    onClicked: win.press("brightness", 0)
                                }
                                Btn {
                                    width: (lightGrid.width - 10) / 2
                                    nav: 1
                                    navCat: "brightness"
                                    label: "Brighter"
                                    onClicked: win.press("brightness", 1)
                                }
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: 12
                            visible: win.selected === "wifi"
                            Big {
                                text: win.wifiRadio === "on" ? (win.wifiActive || "Not connected") : "Off"
                                font.pixelSize: 28
                            }
                            Grid {
                                id: wifiGrid
                                width: parent.width
                                columns: 2
                                columnSpacing: 10
                                rowSpacing: 10
                                Btn {
                                    width: (wifiGrid.width - 10) / 2
                                    nav: 0
                                    navCat: "wifi"
                                    label: win.wifiRadio === "on" ? "Turn off" : "Turn on"
                                    active: win.wifiRadio === "on"
                                    onClicked: win.press("wifi", 0)
                                }
                                Btn { width: (wifiGrid.width - 10) / 2; nav: 1; navCat: "wifi"; label: "Rescan"; onClicked: win.press("wifi", 1) }
                                Btn { width: (wifiGrid.width - 10) / 2; nav: 2; navCat: "wifi"; label: "Disconnect"; onClicked: win.press("wifi", 2) }
                                Btn {
                                    width: (wifiGrid.width - 10) / 2
                                    nav: 3
                                    navCat: "wifi"
                                    label: "Wi-Fi settings"
                                    onClicked: win.press("wifi", 3)
                                }
                            }
                            Repeater {
                                model: win.networks.length
                                delegate: RowItem {
                                    required property int index
                                    nav: 4 + index
                                    navCat: "wifi"
                                    label: win.networks[index].ssid
                                    detail: win.networks[index].active ? "Connected" : win.networks[index].signal + "%"
                                    active: win.networks[index].active || win.pendingSsid === win.networks[index].ssid
                                    onClicked: win.press("wifi", 4 + index)
                                }
                            }
                            Hint {
                                visible: win.pendingSsid !== ""
                                text: "Password for " + win.pendingSsid
                            }
                            Rectangle {
                                visible: win.pendingSsid !== ""
                                width: parent.width
                                height: 46
                                color: theme.bg1
                                border.width: 1
                                border.color: wifiPass.activeFocus ? theme.aqua : theme.bg2
                                TextInput {
                                    id: wifiPass
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    echoMode: TextInput.Password
                                    color: theme.fg
                                    font.family: theme.font
                                    font.pixelSize: 15
                                    clip: true
                                    passwordCharacter: "•"
                                    Keys.onReturnPressed: win.act(["wifi-connect", win.pendingSsid, text])
                                    Keys.onEscapePressed: {
                                        win.pendingSsid = "";
                                        keys.forceActiveFocus();
                                    }
                                }
                            }
                            Btn {
                                visible: win.pendingSsid !== ""
                                width: parent.width
                                nav: 4 + win.networks.length
                                navCat: "wifi"
                                label: "Connect"
                                onClicked: win.press("wifi", 4 + win.networks.length)
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: 12
                            visible: win.selected === "bluetooth"
                            Big {
                                text: win.btPower === "on" ? "On" : "Off"
                                font.pixelSize: 28
                            }
                            Hint {
                                text: win.btState === "up"
                                    ? "Paired devices. Open Bluetooth to pair a new one."
                                    : "Bluetooth is not running yet. Rebuild NixOS, then open it here."
                            }
                            Grid {
                                id: btGrid
                                width: parent.width
                                columns: 2
                                columnSpacing: 10
                                rowSpacing: 10
                                Btn {
                                    width: (btGrid.width - 10) / 2
                                    nav: 0
                                    navCat: "bluetooth"
                                    label: win.btPower === "on" ? "Turn off" : "Turn on"
                                    active: win.btPower === "on"
                                    onClicked: win.press("bluetooth", 0)
                                }
                                Btn { width: (btGrid.width - 10) / 2; nav: 1; navCat: "bluetooth"; label: "Scan"; onClicked: win.press("bluetooth", 1) }
                            }
                            Btn {
                                width: parent.width
                                nav: 2
                                navCat: "bluetooth"
                                label: "Open Bluetooth"
                                onClicked: win.press("bluetooth", 2)
                            }
                            Repeater {
                                model: win.devices.length
                                delegate: RowItem {
                                    required property int index
                                    nav: 3 + index
                                    navCat: "bluetooth"
                                    label: win.devices[index].name
                                    detail: win.devices[index].state === "connected" ? "Connected" : "Paired"
                                    active: win.devices[index].state === "connected"
                                    onClicked: win.press("bluetooth", 3 + index)
                                }
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: 12
                            visible: win.selected === "capture"
                            Big {
                                text: win.recording === "on" ? "Recording" : "Capture"
                                font.pixelSize: 28
                                color: win.recording === "on" ? theme.red : theme.fg
                            }
                            Hint { text: "Region: drag a rectangle, Escape cancels. Screenshots are copied. Recordings go to Videos." }
                            Grid {
                                id: capGrid
                                width: parent.width
                                columns: 2
                                columnSpacing: 10
                                rowSpacing: 10
                                Btn { width: (capGrid.width - 10) / 2; nav: 0; navCat: "capture"; label: "Region"; onClicked: win.press("capture", 0) }
                                Btn { width: (capGrid.width - 10) / 2; nav: 1; navCat: "capture"; label: "This screen"; onClicked: win.press("capture", 1) }
                                Btn { width: (capGrid.width - 10) / 2; nav: 2; navCat: "capture"; label: "This window"; onClicked: win.press("capture", 2) }
                                Btn { width: (capGrid.width - 10) / 2; nav: 3; navCat: "capture"; label: "Picker"; onClicked: win.press("capture", 3) }
                                Btn {
                                    width: (capGrid.width - 10) / 2
                                    nav: 4
                                    navCat: "capture"
                                    label: "Record screen"
                                    active: win.recording === "on"
                                    onClicked: win.press("capture", 4)
                                }
                                Btn { width: (capGrid.width - 10) / 2; nav: 5; navCat: "capture"; label: "Record region"; onClicked: win.press("capture", 5) }
                                Btn {
                                    width: (capGrid.width - 10) / 2
                                    nav: 6
                                    navCat: "capture"
                                    label: "Stop recording"
                                    danger: win.recording === "on"
                                    onClicked: win.press("capture", 6)
                                }
                                Btn {
                                    width: (capGrid.width - 10) / 2
                                    nav: 7
                                    navCat: "capture"
                                    label: "Share screen"
                                    active: win.castCount > 0
                                    onClicked: win.press("capture", 7)
                                }
                            }
                            Btn {
                                width: parent.width
                                nav: 8
                                navCat: "capture"
                                label: "Stop sharing"
                                onClicked: win.press("capture", 8)
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: 12
                            visible: win.selected === "displays"
                            Big {
                                text: win.mirror === "on" ? "Mirroring" : (win.displays.length > 1 ? "Extended" : "Built-in")
                                font.pixelSize: 28
                            }
                            Repeater {
                                model: win.displays.length
                                delegate: RowItem {
                                    required property int index
                                    label: win.displays[index].label
                                    detail: win.displays[index].name
                                    active: win.displays[index].name.indexOf("eDP") === 0
                                }
                            }
                            Grid {
                                id: dispGrid
                                width: parent.width
                                columns: 2
                                columnSpacing: 10
                                rowSpacing: 10
                                Btn { width: (dispGrid.width - 10) / 2; nav: 0; navCat: "displays"; label: "Extend right"; onClicked: win.press("displays", 0) }
                                Btn {
                                    width: (dispGrid.width - 10) / 2
                                    nav: 1
                                    navCat: "displays"
                                    label: "Mirror"
                                    active: win.mirror === "on"
                                    onClicked: win.press("displays", 1)
                                }
                                Btn { width: (dispGrid.width - 10) / 2; nav: 2; navCat: "displays"; label: "Stop mirror"; onClicked: win.press("displays", 2) }
                                Btn { width: (dispGrid.width - 10) / 2; nav: 3; navCat: "displays"; label: "Auto arrange"; onClicked: win.press("displays", 3) }
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: 12
                            visible: win.selected === "session"
                            Big { text: win.battery; font.pixelSize: 28 }
                            Hint { text: "Uptime  " + win.uptime }
                            Hint { text: "Last reboot  " + win.lastLogin }
                            Btn {
                                width: parent.width
                                nav: 0
                                navCat: "session"
                                label: "Lock screen"
                                onClicked: win.press("session", 0)
                            }
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: win.open = false
    }
}
