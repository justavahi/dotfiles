import Quickshell.Io
import QtQuick

Text {
  id: t
  text: ""
  color: "#cca53e"
  font.pixelSize: 14
  font.family: "Ubuntu Mono"
  font.bold: true

  function updateBrightness() {
    brightnessProc.running = true
  }

  Process {
    id: brightnessProc
    command: ["bash", "-c", "doas brightnessctl -m | grep -oP '\\d+(?=%)'"]
    running: true 

    stdout: SplitParser {
      onRead: data => {t.text = "☀️" + data + "%"}
    }
  }

  Timer {
    interval: 100
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: t.updateBrightness()
  }
}

