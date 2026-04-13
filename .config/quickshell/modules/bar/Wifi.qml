import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
  id: wifiRoot
  width: wifiBox.width
  height: wifiBox.height

  property string currentSsid: ""
  property var networks: []

  Rectangle {
    id: wifiBox
    width: wifiText.implicitWidth + 30
    height: 26
    radius: 12
    color: menuPopup.visible ? "#3a3a3a" : "#2a2a2a"
    border.width: 2
    border.color: "#3e3e3e"

    Text {
      id: wifiText
      anchors.centerIn: parent
      text: getWifiText()
      color: "#cca53e"
      font.pixelSize: 14
      font.family: "Ubuntu Mono"
      font.bold: true
    }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        menuPopup.visible = !menuPopup.visible
        if (menuPopup.visible) scanNetworks.running = true
      }
    }
  }

  function getWifiText() {
    if (currentSsid === "") return "Disconnected"
    return currentSsid
  }

  // Текущая сеть
  Process {
    id: wifiProc
    command: ["bash", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        var ssid = data.trim()
        wifiRoot.currentSsid = ssid === "" ? "" : ssid
        wifiText.text = wifiRoot.getWifiText()
      }
    }
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    onTriggered: wifiProc.running = true
  }

  // Сканирование доступных сетей
  Process {
    id: scanNetworks
    command: ["bash", "-c", "nmcli -t -f ssid,signal dev wifi list | head -10"]
    running: false

    stdout: SplitParser {
      onRead: data => {
        var lines = data.trim().split('\n')
        wifiRoot.networks = lines.map(line => {
          var parts = line.split(':')
          return { ssid: parts[0], signal: parts[1] || "0" }
        }).filter(net => net.ssid !== "")
      }
    }
  }

  // Подключение к выбранной сети
  Process {
    id: connectToNetwork
    command: []
    running: false
  }

  // Меню с сетями
  PopupWindow {
    id: menuPopup
    visible: false

    anchor {
      window: wifiRoot
      rect.x: 0
      rect.y: wifiBox.height + 5
      rect.width: 250
    }

    width: 250
    height: Math.min(300, networksList.contentHeight + 20)

    Rectangle {
      anchors.fill: parent
      color: "#2a2a2a"
      border.width: 1
      border.color: "#3e3e3e"
      radius: 8

      Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Text {
          text: "Available Networks"
          color: "#cca53e"
          font.pixelSize: 12
          font.bold: true
        }

        Rectangle {
          width: parent.width
          height: 1
          color: "#3e3e3e"
        }

        ListView {
          id: networksList
          width: parent.width
          height: parent.height - 35
          clip: true

          model: wifiRoot.networks

          delegate: Rectangle {
            width: networksList.width
            height: 30
            color: mouseArea.containsMouse ? "#3a3a3a" : "transparent"
            radius: 4

            RowLayout {
              anchors.fill: parent
              anchors.margins: 5
              spacing: 8

              Text {
                text: "📶"
                font.pixelSize: 14
              }

              Text {
                text: modelData.ssid
                color: "#eeeeec"
                font.pixelSize: 13
                Layout.fillWidth: true
              }

              Text {
                text: modelData.signal + "%"
                color: "#888"
                font.pixelSize: 11
              }
            }

            MouseArea {
              id: mouseArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {
                connectToNetwork.command = ["nmcli", "device", "wifi", "connect", modelData.ssid]
                connectToNetwork.running = true
                menuPopup.visible = false
                // Обновить текущую сеть через 2 секунды
                updateTimer.start()
              }
            }
          }
        }
      }
    }
  }

  // Таймер для обновления текущей сети после подключения
  Timer {
    id: updateTimer
    interval: 2000
    running: false
    repeat: false
    onTriggered: wifiProc.running = true
  }
}

