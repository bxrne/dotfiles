import QtQuick
import Quickshell
import Quickshell.Services.Notifications

PanelWindow {
    id: win
    required property QtObject theme

    anchors.top: true
    anchors.left: true
    anchors.right: true
    exclusiveZone: 0
    aboveWindows: true
    color: "transparent"
    margins.top: 18
    visible: stack.count > 0
    implicitHeight: stack.implicitHeight + 4

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        onNotification: n => {
            n.tracked = true;
            const items = server.trackedNotifications.values || [];
            while (items.length > 3)
                items[0].dismiss();
        }
    }

    Column {
        id: stack
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        width: theme.slotW * 2 + 10
        property int count: server.trackedNotifications.values ? server.trackedNotifications.values.length : 0

        Repeater {
            model: server.trackedNotifications
            delegate: Rectangle {
                required property Notification modelData
                width: stack.width
                height: 78
                radius: 0
                antialiasing: false
                color: theme.bg
                border.width: 1
                border.color: modelData.urgency === NotificationUrgency.Critical ? theme.red : theme.bg2

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 12
                    text: (modelData.appName || "NOTICE").toUpperCase()
                    color: theme.fgDim
                    font.family: theme.font
                    font.pixelSize: 11
                }
                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    anchors.bottomMargin: bodyLabel.text ? 28 : 14
                    text: modelData.summary || "notification"
                    color: theme.fg
                    font.family: theme.font
                    font.pixelSize: 16
                    elide: Text.ElideRight
                }
                Text {
                    id: bodyLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 12
                    visible: text.length > 0
                    text: (modelData.body || "").replace(/<[^>]+>/g, "")
                    color: theme.fgDim
                    font.family: theme.font
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.dismiss()
                }

                Timer {
                    interval: modelData.expireTimeout > 0 ? modelData.expireTimeout : 4500
                    running: modelData.urgency !== NotificationUrgency.Critical && modelData.expireTimeout !== 0
                    repeat: false
                    onTriggered: modelData.expire()
                }
            }
        }
    }
}
