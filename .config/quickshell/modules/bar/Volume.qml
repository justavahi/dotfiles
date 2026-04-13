import Quickshell.Io
import QtQuick

Text {
    id: volumeText
    text: "󰖁"
    font.pixelSize: 14
    font.family: "Ubuntu Mono"
    font.bold: true
    
    property int volume: 0
    property bool muted: false
    
    function updateVolume() {
        volumeProc.running = true
    }
    
    function getVolumeIcon() {
      if (muted) { /* muted */
            return "󰖁"  // \uf581 - muted icon
        }
        
        if (volume === 0) {
            return "󰕿"  // \uf57f - volume off
        } else if (volume < 30) {
            return "󰖀 " + volume + "%"  // \uf580 - volume low
        } else if (volume < 70) {
            return "󰕾 " + volume + "%" // \uf57e - volume medium
        } else {
            return "󰕾 " + volume + "%"  // \uf57e - volume high
        }
    }
    
    function getVolumeColor() {
        if (muted || volume === 0) return "#585b70"  // MUTED
        if (volume > 100)          return "#ff0000"  // CRITICAL VOLUME
        return "#cca53e"
    }
    
    Process {
        id: volumeProc
        command: ["bash", "-c", 
            "output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@); " +
            "vol=$(echo $output | grep -oP '\\d+\\.\\d+' | awk '{print int($1*100)}'); " +
            "mute=$(echo $output | grep -c 'MUTED'); " +
            "echo \"$vol|$mute\""
        ]
        running: false
        
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split('|')
                if (parts.length >= 2) {
                    volumeText.volume = parseInt(parts[0]) || 0
                    volumeText.muted = parts[1] === "1"
                    
                    volumeText.text = volumeText.getVolumeIcon()
                    volumeText.color = volumeText.getVolumeColor()
                }
            }
        }
    }
    
    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: volumeText.updateVolume()
    }
}

