import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    QtObject {
        id: theme
        readonly property color bg: "#1d2021"
        readonly property color bgSoft: "#282828"
        readonly property color bg1: "#3c3836"
        readonly property color bg2: "#504945"
        readonly property color fg: "#ebdbb2"
        readonly property color fgDim: "#928374"
        readonly property color bright: "#fbf1c7"
        readonly property color aqua: "#8ec07c"
        readonly property color red: "#fb4934"
        readonly property string font: "JetBrainsMono Nerd Font"
        readonly property int radius: 0
        readonly property int pad: 16
        readonly property int slotW: 248
        readonly property int slotH: 156
    }

    Launcher {
        id: launcher
        theme: theme
    }

    ControlCenter {
        id: center
        theme: theme
    }

    Notifications {
        theme: theme
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            center.open = false;
            launcher.toggle();
        }
    }

    IpcHandler {
        target: "center"
        function toggle() {
            launcher.close();
            center.toggle();
        }
    }
}
