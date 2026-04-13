import Quickshell.Io
import QtQuick

Text {
  id: batteryText
  text: "BAT: --%"
  font.pixelSize: 14
  font.family: "Ubuntu Mono"  // for icons
  font.bold: true

  property int capacity: 0
  property string status: ""

  function updateBattery() {
    capacityProc.running = true // capacity
    statusProc.running = true // read status
  }

  function getBatteryText() {
    if (status === "Charging") { return capacity + "% ⚡" } /* CHARGING */

    if (capacity < 10) {return "󰂃 " + capacity + "%"}
    if (capacity < 20) {return "󰁻 " + capacity + "%"}
    if (capacity < 50) {return "󰁼 " + capacity + "%"}
    if (capacity < 70) {return "󰁾 " + capacity + "%"}
    if (capacity < 90) {return "󰂂 " + capacity + "%"}

    return "󰁹 " + capacity + "%"
  }

  function getBatteryColor() {
    if (status === "Charging") return "#cca53e"

    if (capacity <= 10) return "#ff0000"  // dangerous color 
    if (capacity <= 15) return "#f38ba8"  // critical color 
    if (capacity <= 20) return "#fab387"  // warning  color
    return "#cca53e"  // default color
  }

  Process {
    id: capacityProc
    command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
    running: false

    stdout: SplitParser {
      onRead: data => {
        var cap = parseInt(data.trim())

        if (!isNaN(cap)) {
          batteryText.capacity = cap
          batteryText.text = batteryText.getBatteryText()
          batteryText.color = batteryText.getBatteryColor()
        }
      }
    }
  }

  Process {
    id: statusProc
    command: ["cat", "/sys/class/power_supply/BAT0/status"]
    running: false

    stdout: SplitParser {
      onRead: data => {
        batteryText.status = data.trim()
        batteryText.text = batteryText.getBatteryText()
        batteryText.color = batteryText.getBatteryColor()
      }
    }
  }

  // timer for updating every 5 seconds
  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: batteryText.updateBattery()
  }
}

