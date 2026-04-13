import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: bar
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 30
  color: "#161616"

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 12
    anchors.rightMargin: 12
    spacing: 16

    Wifi {}

    Item { Layout.fillWidth: true }
    Clock {
      Layout.alignment: Qt.AlignCenter
    }
    Item { Layout.fillWidth: true }

    RowLayout {
      spacing: 15
      Layout.alignment: Qt.AlignRight

      Ram {}
      Volume {}
      Text { 
        text: "|" 
        color: "#cca53e"
      }
      Bat {}
    }
  }
}

