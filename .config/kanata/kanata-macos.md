# How to install Kanata on macOS

The instructions are inspired by
  - https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice#usage
  - https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice#run-karabiner-virtualhiddevice-daemon-via-launchd
  - https://github.com/jtroo/kanata/discussions/1086

Be aware! Steps might be missing or even wrong for your usecase. They were
written after I got it to work and I tried to backstep as accurate as I could.

## Download and install karabiner virtual HID device driver

```
curl --output-dir ${HOME}/Downloads -O https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v5.0.0/Karabiner-DriverKit-VirtualHIDDevice-5.0.0.pkg
```

Install above package as usual (doubble-click, use default options) and then
run

```
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
```

Go to `Settings->Login Items & Extensions->Extension->Driver Extension (i)` and
enable the driver for karabiner.

## Auto start karabiner daemon with launchd

```
curl --output-dir ${HOME}/Downloads -O https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/raw/refs/heads/main/files/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo mv ${HOME}/Downloads/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist /Library/LaunchDaemons/.
sudo launchctl bootstrap system /Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo launchctl enable system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
```

## Download and install kanata

```
curl --output-dir ${HOME}/Downloads -O https://github.com/jtroo/kanata/releases/download/v1.8.0-prerelease-1/kanata_macos_arm64
chmod +x ${HOME}/Downloads/kanata_macos_arm64
sudo mv ${HOME}/Downloads/kanata_macos_arm64 /usr/local/bin/.
```

## Auto start kanata with launchd

```
cat <<EOF | sudo tee "/Library/LaunchDaemons/com.jtroo.kanata.plist" > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jtroo.kanata</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/kanata_macos_arm64</string>
        <string>--quiet</string>
        <string>--cfg</string>
        <string>${HOME}/.config/kanata/config.kbd</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardErrorPath</key>
    <string>/var/log/kanata.error.log</string>

    <key>StandardOutPath</key>
    <string>/var/log/kanata.output.log</string>
</dict>
</plist>
EOF
sudo launchctl bootstrap system /Library/LaunchDaemons/com.jtroo.kanata.plist
sudo launchctl enable system/com.jtroo.kanata.plist
```

## How to restart kanata after config update

```
sudo launchctl stop system/com.jtroo.kanata.plist
sudo launchctl start system/com.jtroo.kanata.plist
```

