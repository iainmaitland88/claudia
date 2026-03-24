#!/bin/bash
# Install claudia launchd agents for check-in and weekly review reminders.
# Usage: install-launchd.sh PROJECT_PATH CHECKIN_HOUR CHECKIN_MINUTE WEEKLY_DAY WEEKLY_HOUR WEEKLY_MINUTE
#
# WEEKLY_DAY: 0=Sunday, 1=Monday, ..., 5=Friday, 6=Saturday

set -euo pipefail

PROJECT_PATH="$1"
CHECKIN_HOUR="$2"
CHECKIN_MINUTE="$3"
WEEKLY_DAY="$4"
WEEKLY_HOUR="$5"
WEEKLY_MINUTE="$6"

AGENTS_DIR="$HOME/Library/LaunchAgents"
CHECKIN_LABEL="com.claudia.checkin-reminder"
WEEKLY_LABEL="com.claudia.weekly-reminder"
CHECKIN_PLIST="$AGENTS_DIR/$CHECKIN_LABEL.plist"
WEEKLY_PLIST="$AGENTS_DIR/$WEEKLY_LABEL.plist"

mkdir -p "$AGENTS_DIR"

# Unload existing agents if loaded
launchctl bootout "gui/$(id -u)/$CHECKIN_LABEL" 2>/dev/null || true
launchctl bootout "gui/$(id -u)/$WEEKLY_LABEL" 2>/dev/null || true

# Build the checkin weekday entries (1=Mon through 5=Fri).
# If the weekly review lands on a weekday at the same time, exclude that day.
checkin_days=""
for day in 1 2 3 4 5; do
    if [ "$day" -eq "$WEEKLY_DAY" ] && [ "$CHECKIN_HOUR" -eq "$WEEKLY_HOUR" ] && [ "$CHECKIN_MINUTE" -eq "$WEEKLY_MINUTE" ]; then
        continue
    fi
    checkin_days="$checkin_days        <dict>
            <key>Weekday</key>
            <integer>$day</integer>
            <key>Hour</key>
            <integer>$CHECKIN_HOUR</integer>
            <key>Minute</key>
            <integer>$CHECKIN_MINUTE</integer>
        </dict>
"
done

# Write checkin plist
cat > "$CHECKIN_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$CHECKIN_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PROJECT_PATH/scripts/checkin-reminder.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <array>
$checkin_days    </array>
</dict>
</plist>
EOF

# Write weekly plist
cat > "$WEEKLY_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$WEEKLY_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PROJECT_PATH/scripts/weekly-reminder.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>$WEEKLY_DAY</integer>
        <key>Hour</key>
        <integer>$WEEKLY_HOUR</integer>
        <key>Minute</key>
        <integer>$WEEKLY_MINUTE</integer>
    </dict>
</dict>
</plist>
EOF

# Load agents
launchctl bootstrap "gui/$(id -u)" "$CHECKIN_PLIST"
launchctl bootstrap "gui/$(id -u)" "$WEEKLY_PLIST"

echo "Installed and loaded:"
echo "  $CHECKIN_PLIST"
echo "  $WEEKLY_PLIST"
