import Quickshell
import Quickshell.Io
import QtQuick

Item {
  id: clockRoot
  implicitWidth: clockText.implicitWidth
  implicitHeight: clockText.height

  property bool showDate: false  // false = time, true = date

  Text {
    id: clockText
    text: updateClock()
    color: "#cca53e"
    font.pixelSize: 14
    font.family: "Ubuntu Mono"
    font.bold: true

    MouseArea {
      anchors.fill: parent
      onClicked: {
        clockRoot.showDate = !clockRoot.showDate
        clockText.text = clockRoot.updateClock()
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: clockText.text = clockRoot.updateClock()
  }

  function updateClock() {
    var now = new Date()

    if (showDate) {
      // Day in week, day.month.year
      var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      var dayName = days[now.getDay()]
      var day = String(now.getDate()).padStart(2, '0')
      var month = String(now.getMonth() + 1).padStart(2, '0')
      var year = now.getFullYear()
      return dayName + ", " + day + "." + month + "." + year
    } else {
      // Time in format h:m:s
      var hours = String(now.getHours()).padStart(2, '0')
      var minutes = String(now.getMinutes()).padStart(2, '0')
      var seconds = String(now.getSeconds()).padStart(2, '0')
      return hours + ":" + minutes + ":" + seconds
    }
  }
}

