import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

Item {
  id: root

  // ---- TuningTuning  ----
  property int toastWidth: 420
  property int maxVisible: 6
  property int defaultTimeoutMs: 6000
  property int criticalTimeoutMs: 0 // 0 = don't close by himself
  property int spacing: 10
  property int radius: 14

  property color bg:       "#161616"
  property color border:   "#cca53e"
  property color text:     "#ddb64f"
  property color subtext:  "#cca53e"
  property color accent:   "#92C27C"
  property color critical: "#f7768e"

  ListModel { id: toastModel }

  function _timeoutFor(n) {
    if (n && typeof n.expireTimeout === "number" && n.expireTimeout > 0) return n.expireTimeout;
    if (n && typeof n.timeout === "number" && n.timeout > 0) return n.timeout;
    if (n && n.urgency === NotificationUrgency.Critical) return criticalTimeoutMs;
    return defaultTimeoutMs;
  }

  function _closeBackend(n) {
    try { if (n && typeof n.close === "function") n.close(); } catch (e) {}
  }

  function pushNotification(n) {
    if (!n) return;

    while (toastModel.count >= maxVisible) toastModel.remove(0);

    toastModel.append({
      notif: n,
      timeoutMs: _timeoutFor(n),
      createdMs: Date.now()
    });
  }

  NotificationServer {
    id: server
    onNotification: (n) => root.pushNotification(n) }

    // Pseudo Window for messages
    PanelWindow {
      id: w

      anchors { right: true; top: true }
      margins { right: 18; top: 18 }

      color: "transparent"

      implicitWidth: root.toastWidth
      implicitHeight: stack.implicitHeight

      mask: Region { item: stack } // DON'T BLOCK CLICKS ON WORKSPACE OUT OF TOSTS

      // Render in fullscreen mode
      Component.onCompleted: {
        if (w.WlrLayershell != null) w.WlrLayershell.layer = WlrLayer.Overlay;
      }

      Column {
        id: stack
        width: root.toastWidth
        spacing: root.spacing

        Repeater {
          model: toastModel

          delegate: Item {
            id: toast
            width: root.toastWidth
            implicitHeight: card.implicitHeight

            required property var notif
            required property int timeoutMs
            required property double createdMs
            required property int index

            property bool hovered: false
            property double lastTickMs: Date.now()
            property int remainingMs: timeoutMs

            opacity: 0
            x: 22

            Component.onCompleted: {
              appear.start();
              lastTickMs = Date.now();
            }

            SequentialAnimation {
              id: appear
              ParallelAnimation {
                NumberAnimation { target: toast; property: "opacity"; to: 1; duration: 140; easing.type: Easing.OutCubic }
                NumberAnimation { target: toast; property: "x"; to: 0; duration: 220; easing.type: Easing.OutCubic }
              }
            }

            Timer {
              interval: 50
              repeat: true
              running: toast.timeoutMs > 0
              onTriggered: {
                const now = Date.now();
                const dt = now - toast.lastTickMs;
                toast.lastTickMs = now;

                if (toast.hovered) return;

                toast.remainingMs = Math.max(0, toast.remainingMs - dt);
                if (toast.remainingMs === 0) {
                  toastModel.remove(toast.index);
                  root._closeBackend(toast.notif);
                }
              }
            }

            Rectangle {
              id: card
              width: parent.width
              implicitHeight: content.implicitHeight
              radius: root.radius

              color: root.bg
              border.width: 1
              border.color: (toast.notif.urgency === NotificationUrgency.Critical) ? root.critical : root.border

              /* SHADOW */
              Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: card.radius + 2
                color: "#55000000"
                z: -1
              }

              HoverHandler { onHoveredChanged: toast.hovered = hovered }

              ColumnLayout {
                id: content
                width: parent.width
                spacing: 10

                RowLayout {
                  spacing: 10
                  Layout.fillWidth: true

                  /* ICON */
                  Image {
                    visible: source !== ""
                    source: (toast.notif.appIcon || "")
                    sourceSize.width: 28
                    sourceSize.height: 28
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                  }

                  ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                      text: toast.notif.summary || ""
                      color: root.text
                      font.pixelSize: 16
                      font.weight: 600
                      elide: Text.ElideRight
                      wrapMode: Text.NoWrap
                      Layout.fillWidth: true
                    }

                    Text {
                      text: toast.notif.body || ""
                      color: root.subtext
                      font.pixelSize: 13
                      wrapMode: Text.Wrap
                      textFormat: Text.PlainText
                      Layout.fillWidth: true
                      visible: text.length > 0
                    }
                  }

                  ToolButton {
                    id: closeBtn
                    text: "×"
                    font.pixelSize: 13

                    contentItem: Text {
                      text: closeBtn.text
                      font: closeBtn.font
                      color: border
                      horizontalAlignment: Text.AlignHCenter
                      verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                      radius: 10
                      color:closeBtn.down ? "#33ffffff" : (closeBtn.hovered ? "#22ffffff" : "transparent")
                    }

                    onClicked: {
                      toastModel.remove(toast.index)
                      root._closeBackend(toast.notif)
                    }
                  }
                }

                Image {
                  visible: source !== ""
                  source: (toast.notif.image || "")
                  fillMode: Image.PreserveAspectFit
                  antialiasing: true
                  cache: false
                  Layout.fillWidth: true
                  sourceSize.width: 380
                }

                RowLayout {
                  Layout.fillWidth: true
                  spacing: 8
                  visible: toast.notif.actions && toast.notif.actions.length > 0

                  Repeater {
                    model: toast.notif.actions || []

                    delegate: Button {
                      required property var modelData
                      text: modelData.text || ""

                      onClicked: {
                        try { modelData.invoke(); } catch (e) {}
                        toastModel.remove(toast.index);
                      }

                      background: Rectangle {
                        radius: 10
                        color: parent.down ? "#2a2f3a" : "#232834"
                        border.width: 1
                        border.color: "#2f3646"
                      }

                      contentItem: Text {
                        text: parent.text
                        color: root.text
                        font.pixelSize: 13
                        elide: Text.ElideRight
                      }
                    }
                  }

                  Item { Layout.fillWidth: true }
                }

                Rectangle {
                  Layout.fillWidth: true
                  height: 3
                  radius: 2
                  color: "#1d212b"
                  visible: toast.timeoutMs > 0

                  Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * (toast.remainingMs / Math.max(1, toast.timeoutMs))
                    radius: 2
                    color: (toast.notif.urgency === NotificationUrgency.Critical) ? root.critical : root.accent
                  }
                }
              }

              MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onClicked: {
                  toastModel.remove(toast.index);
                  root._closeBackend(toast.notif);
                }
              }
            }
          }
        }
      }
    }
  }
