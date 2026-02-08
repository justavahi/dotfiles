import Quickshell.Io
import QtQuick

Text {
  id: t
  property string ssid: ""

  text: ssid.length ? ssid : "Disconnected"
  color: "#cca53e"
  font.pixelSize: 14
  font.family: "Ubuntu Mono"
  font.bold: true

  Process {
    id: p
    command: ["bash", "-c", "wpa_cli -i wlo1 status | grep '^ssid' | cut -d = -f2"]
    running: true
    stdout: StdioCollector { onStreamFinished: t.ssid = this.text.trim() }
  }

  Timer { interval: 2000; running: true; repeat: true; onTriggered: p.running = true }
}
