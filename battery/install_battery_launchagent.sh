#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
AGENT_LABEL="com.user.batteryalert"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$LAUNCH_AGENTS_DIR/${AGENT_LABEL}.plist"
BATTERY_SCRIPT="$SCRIPT_DIR/battery_alert.sh"
LOG_OUT="$SCRIPT_DIR/battery_alert.log"
LOG_ERR="$SCRIPT_DIR/battery_alert.err"

mkdir -p "$LAUNCH_AGENTS_DIR"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${AGENT_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${BATTERY_SCRIPT}</string>
    </array>
    <key>StartInterval</key>
    <integer>60</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
    <key>StandardOutPath</key>
    <string>${LOG_OUT}</string>
    <key>StandardErrorPath</key>
    <string>${LOG_ERR}</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)" "$PLIST_PATH" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
launchctl enable "gui/$(id -u)/${AGENT_LABEL}"
launchctl kickstart -k "gui/$(id -u)/${AGENT_LABEL}"

echo "Battery alert LaunchAgent installed and started."
echo "Plist: $PLIST_PATH"
echo "Check status with: launchctl print gui/$(id -u)/${AGENT_LABEL} | head -n 60"
