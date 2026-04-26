import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Widgets

ShellRoot {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  property bool shouldShowOsd: false

  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource ]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio

    function onVolumeChanged() {
      root.shouldShowOsd = true;
      hideTimer.restart();
    }

    //function onMutedChanged() {
    //  root.shouldShowOsd = true;
    //  hideTimer.restart();
    //}
  }

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: root.shouldShowOsd = false
  }

  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      anchors.top: true
      margins.top: screen.height / 10
      exclusiveZone: 0

      implicitWidth: 400
      implicitHeight: 50
      color: "transparent"

      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "#80000000"

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 15
          }

          IconImage {
            implicitSize: 30
            source: Quickshell.iconPath("audio-volume-high-symbolic")
          }

          Rectangle {
            Layout.fillWidth: true

            implicitHeight: 10
            radius: 20
            color: "#50ffffff"

            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }

              implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
              radius: parent.radius
            }
          }
        }
      }
    }
  }

  // Theme colors
  property color colBg: "#1a1b26"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colPurple: "#ad8ee6"
  property color colRed: "#f7768e"
  property color colYellow: "#e0af68"
  property color colBlue: "#7aa2f7"

  // Font
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  // System info properties
  property string kernelVersion: "Linux"
  property int cpuUsage: 0
  property int memUsage: 0
  property int diskUsage: 0
  property string activeWindow: "Window"
  property string currentLayout: "Tile"
  property int audio: Math.round(100*(Pipewire.defaultAudioSink?.audio.volume ?? 0))
  property int mic: Math.round(100*(Pipewire.defaultAudioSource?.audio.volume ?? 0))
  property bool audioMuted: Pipewire.defaultAudioSink?.audio.muted
  property bool micMuted: Pipewire.defaultAudioSource?.audio.muted
  //property int bat: Math.round(100*(UPowerDevice.percentage ?? 0))
  property real bat: UPowerDevice.percentage

  // CPU tracking
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

  // Kernel version
  Process {
    id: kernelProc
    command: ["uname", "-r"]
    stdout: SplitParser {
      onRead: data => {
        if (data) kernelVersion = data.trim()
      }
    }
    Component.onCompleted: running = true
  }

  // CPU usage
  Process {
    id: cpuProc
    command: ["sh", "-c", "head -1 /proc/stat"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var user = parseInt(parts[1]) || 0
        var nice = parseInt(parts[2]) || 0
        var system = parseInt(parts[3]) || 0
        var idle = parseInt(parts[4]) || 0
        var iowait = parseInt(parts[5]) || 0
        var irq = parseInt(parts[6]) || 0
        var softirq = parseInt(parts[7]) || 0

        var total = user + nice + system + idle + iowait + irq + softirq
        var idleTime = idle + iowait

        if (lastCpuTotal > 0) {
          var totalDiff = total - lastCpuTotal
          var idleDiff = idleTime - lastCpuIdle
          if (totalDiff > 0) {
            cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
          }
        }
        lastCpuTotal = total
        lastCpuIdle = idleTime
      }
    }
    Component.onCompleted: running = true
  }

  // Memory usage
  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var total = parseInt(parts[1]) || 1
        var used = parseInt(parts[2]) || 0
        memUsage = Math.round(100 * used / total)
      }
    }
    Component.onCompleted: running = true
  }

  // Disk usage
  Process {
    id: diskProc
    command: ["sh", "-c", "df / | tail -1"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var percentStr = parts[4] || "0%"
        diskUsage = parseInt(percentStr.replace('%', '')) || 0
      }
    }
    Component.onCompleted: running = true
  }

  // Active window title
  Process {
    id: windowProc
    command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
    stdout: SplitParser {
      onRead: data => {
        if (data && data.trim()) {
          activeWindow = data.trim()
        }
      }
    }
    Component.onCompleted: running = true
  }

  // Current layout (Hyprland: dwindle/master/floating)
  Process {
    id: layoutProc
    command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
    stdout: SplitParser {
      onRead: data => {
        if (data && data.trim()) {
          currentLayout = data.trim()
        }
      }
    }
    Component.onCompleted: running = true
  }

  // Slow timer for system stats
  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = true
      memProc.running = true
      diskProc.running = true
    }
  }

  // Event-based updates for window/layout (instant)
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      windowProc.running = true
      layoutProc.running = true
    }
  }

  // Backup timer for window/layout (catches edge cases)
  Timer {
    interval: 200
    running: true
    repeat: true
    onTriggered: {
      windowProc.running = true
      layoutProc.running = true
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30
      color: root.colBg

      margins {
        top: 0
        bottom: 0
        left: 0
        right: 0
      }

      Rectangle {
        anchors.fill: parent
        color: root.colBg

        RowLayout {
          anchors.fill: parent
          spacing: 0

          Item { width: 8 }

          Repeater {
            model: 9

            Rectangle {
              Layout.preferredWidth: 20
              Layout.preferredHeight: parent.height
              color: "transparent"

              property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
              property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
              property bool hasWindows: workspace !== null

              Text {
                text: index + 1
                color: parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted)
                font.pixelSize: root.fontSize
                font.family: root.fontFamily
                font.bold: true
                anchors.centerIn: parent
              }

              Rectangle {
                width: 20
                height: 3
                color: parent.isActive ? root.colPurple : root.colBg
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
              }

              MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
              }
            }
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 4
            Layout.rightMargin: 0
            color: root.colMuted
          }

          Text {
            text: currentLayout
            color: root.colFg
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.leftMargin: 8
            Layout.rightMargin: 0
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 8
            Layout.rightMargin: 0
            color: root.colMuted
          }

          Text {
            text: activeWindow
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.fillWidth: true
            Layout.leftMargin: 8
            elide: Text.ElideRight
            maximumLineCount: 1
          }

          Text {
            text: kernelVersion
            color: root.colRed
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 0
            Layout.rightMargin: 8
            color: root.colMuted
          }

          Text {
            text: "CPU: " + cpuUsage + "%"
            color: root.colYellow
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 0
            Layout.rightMargin: 8
            color: root.colMuted
          }

          Text {
            text: "Mem: " + memUsage + "%"
            color: root.colCyan
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 0
            Layout.rightMargin: 8
            color: root.colMuted
          }

          Text {
            text: "Disk: " + diskUsage + "%"
            color: root.colBlue
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 0
            Layout.rightMargin: 8
            color: root.colMuted
          }

          Text {
            text: audio + "%"
            horizontalAlignment: Text.AlignRight
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.preferredWidth: 35
            Layout.maximumWidth: 35
            Layout.rightMargin: 4
          }

          Text {
            // 󰖁   
            text: root.audioMuted ? "󰖁" : audio < 34 ? "" : audio < 67 ? "" : ""
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.preferredWidth: 16
            Layout.maximumWidth: 16
            Layout.rightMargin: 8
          }

          Text {
            text: mic + "%"
            horizontalAlignment: Text.AlignRight
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.preferredWidth: 35
            Layout.maximumWidth: 35
            Layout.rightMargin: 4
          }

          Text {
            // 󰍭 
            text: (micMuted ? "󰍭" : "")
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.preferredWidth: 8
            Layout.maximumWidth: 8
            Layout.rightMargin: 8
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 0
            Layout.rightMargin: 8
            color: root.colMuted
          }

          Text {
            text: bat + "%"
            horizontalAlignment: Text.AlignRight
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.preferredWidth: 35
            Layout.maximumWidth: 35
            Layout.rightMargin: 4
          }

          Text {
            //     
            text: (bat < 20 ? "" : bat < 40 ? "" : bat < 60 ? "" : bat < 80 ? "" : "")
            color: root.colPurple
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.preferredWidth: 16
            Layout.maximumWidth: 16
            Layout.rightMargin: 8
          }

          Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 0
            Layout.rightMargin: 8
            color: root.colMuted
          }

          Text {
            text: Qt.formatDateTime(clock.date, "ddd, MMM dd - HH:mm")
            color: root.colCyan
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
          }

          Item { width: 8 }
        }
      }
    }
  }
}

