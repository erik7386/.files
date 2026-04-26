# How to install Kanata on macOS

The instructions are inspired by
  - https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice#usage
  - https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice#run-karabiner-virtualhiddevice-daemon-via-launchd
  - https://github.com/jtroo/kanata/discussions/1086

Be aware! Steps might be missing or even wrong for your usecase. They were
written after I got it to work and I tried to backstep as accurate as I could.

## Remove all

Remove kanata

```
sudo launchctl stop system/com.jtroo.kanata.plist
sudo launchctl disable system/com.jtroo.kanata.plist
sudo launchctl bootout system /Library/LaunchDaemons/com.jtroo.kanata.plist
sudo rm -f /Library/LaunchDaemons/com.jtroo.kanata.plist
sudo rm -f /usr/local/bin/kanata_macos_arm64
sudo rm -f /var/log/kanata.*
```

Remove Karabiner-VirtualHIDDevice-Daemon

```
sudo launchctl disable system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
bash '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/scripts/uninstall/deactivate_driver.sh'
sudo bash '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/scripts/uninstall/remove_files.sh'
sudo killall Karabiner-VirtualHIDDevice-Daemon
sudo rm -rf /var/log/karabiner
```

## Download and install karabiner virtual HID device driver

```
curl --output-dir ${HOME}/Downloads -L -O https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v6.2.0/Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg
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
curl --output-dir ${HOME}/Downloads -L -O https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/raw/refs/heads/main/files/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo mv ${HOME}/Downloads/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist /Library/LaunchDaemons/.
sudo chown root:wheel /Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo chmod 644 /Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo launchctl bootout system /Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
sudo launchctl enable system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist
```

## Download and install kanata

```
brew update && brew upgrade
brew install kanata
#curl --output-dir ${HOME}/Downloads -L -O https://github.com/jtroo/kanata/releases/download/v1.10.1/kanata-macos-binaries-arm64-v1.10.1.zip
#unzip ${HOME}/Downloads/kanata-macos-binaries-arm64-v1.10.1.zip -d ${HOME}/Downloads/kanata-macos-binaries-arm64-v1.10.1
#mv ${HOME}/Downloads/kanata-macos-binaries-arm64-v1.10.1/kanata_macos_arm64 ${HOME}/Downloads/kanata-macos-binaries-arm64-v1.10.1/kanata
#sudo install -g wheel -m 0755 -o root ${HOME}/Downloads/kanata-macos-binaries-arm64-v1.10.1/kanata /usr/local/bin/
```

## Auto start kanata with launchd

```
cat <<EOF | sudo tee "/Library/LaunchDaemons/kanata.plist" > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>kanata</string>

    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/kanata</string>
        <string>--quiet</string>
        <string>--cfg</string>
        <string>${HOME}/.config/kanata/hrm-macbookpro.kbd</string>
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
sudo launchctl bootstrap system /Library/LaunchDaemons/kanata.plist
sudo launchctl enable system/kanata.plist
```

## How to restart kanata after config update

```
sudo launchctl stop system/com.jtroo.kanata.plist
sudo launchctl start system/com.jtroo.kanata.plist
```

