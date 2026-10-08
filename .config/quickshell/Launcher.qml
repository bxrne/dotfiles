import QtQuick
import Quickshell

PanelWindow {
    id: win
    required property QtObject theme
    property bool open: false
    property string query: ""
    property int selected: 0

    visible: open
    focusable: true
    aboveWindows: true
    exclusiveZone: 0
    color: "#00000088"
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    function apps() {
        const model = DesktopEntries.applications;
        const values = model.values || [];
        const q = query.trim().toLowerCase();
        const out = [];
        for (let i = 0; i < values.length; i++) {
            const e = values[i];
            if (!e || e.noDisplay)
                continue;
            const name = (e.name || "").toLowerCase();
            const id = (e.id || "").toLowerCase();
            if (/(client|server|daemon)/.test(name) || /(client|server|daemon)/.test(id))
                continue;
            if (q && !name.includes(q) && !(e.genericName || "").toLowerCase().includes(q) && !id.includes(q))
                continue;
            out.push(e);
            if (out.length >= 8)
                break;
        }
        out.sort((a, b) => a.name.localeCompare(b.name));
        return out;
    }

    function launch(entry) {
        if (!entry)
            return;
        entry.execute();
        close();
    }

    function close() {
        open = false;
        query = "";
        selected = 0;
    }

    function toggle() {
        open = !open;
        if (open)
            Qt.callLater(() => input.forceActiveFocus());
    }

    onOpenChanged: if (open)
        Qt.callLater(() => input.forceActiveFocus())

    Column {
        anchors.centerIn: parent
        spacing: 10
        width: theme.slotW * 2 + 10

        Rectangle {
            width: parent.width
            height: 64
            radius: 0
            color: theme.bg
            border.width: 1
            border.color: input.activeFocus ? theme.aqua : theme.bg2

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                text: "LAUNCH"
                color: theme.fgDim
                font.family: theme.font
                font.pixelSize: 11
            }

            TextInput {
                id: input
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 12
                anchors.bottomMargin: 10
                color: theme.fg
                font.family: theme.font
                font.pixelSize: 18
                clip: true
                onTextChanged: {
                    win.query = text;
                    win.selected = 0;
                }
                Keys.onEscapePressed: win.close()
                Keys.onUpPressed: win.selected = Math.max(0, win.selected - 1)
                Keys.onDownPressed: win.selected = Math.min(Math.max(grid.count - 1, 0), win.selected + 1)
                Keys.onReturnPressed: win.launch(grid.model[win.selected])
                Keys.onEnterPressed: win.launch(grid.model[win.selected])
            }

            Text {
                anchors.left: input.left
                anchors.verticalCenter: input.verticalCenter
                visible: input.text.length === 0 && !input.activeFocus
                text: "search apps"
                color: theme.fgDim
                font.family: theme.font
                font.pixelSize: 18
            }
        }

        Grid {
            id: grid
            width: parent.width
            columns: 2
            columnSpacing: 10
            rowSpacing: 10
            property var model: win.apps()

            Repeater {
                model: grid.model
                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: theme.slotW
                    height: 72
                    radius: 0
                    color: theme.bg
                    border.width: index === win.selected ? 2 : 1
                    border.color: index === win.selected ? theme.aqua : theme.bg2

                    Text {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: 10
                        text: "APP"
                        color: theme.fgDim
                        font.family: theme.font
                        font.pixelSize: 11
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 12
                        text: modelData.name
                        color: index === win.selected ? theme.bright : theme.fg
                        font.family: theme.font
                        font.pixelSize: 16
                        elide: Text.ElideRight
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: win.selected = index
                        onClicked: win.launch(modelData)
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: win.close()
    }
}
